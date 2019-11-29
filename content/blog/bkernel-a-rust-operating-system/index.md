---
title: 'bkernel: a Rust Operating System'
author: Alexey Shmalko
tags: bkernel,rust,osdev
keywords: rust,operating system,embedded
description: I'm writing an operating system in Rust and here is my status and impressions after a month of development.
date: 2015-11-30
---

_**TL;DR** I'm writing an operating system in [Rust](https://www.rust-lang.org/) and here is my status and impressions after a month of development._

I've been developing embedded operating systems for living for a couple of years now. And... I got tired of work, all the bureaucracy, hard to debug issues, a zillion of low-level details; I wasn't even sure I want to continue work in the field, so I started a side project. It may come as a surprise I started yet another operating system when the same thing led me to this. Well, it's not same; I'm building a new operating system to experiment, and this refuels me with the passion to the field.

Here are my progress and some impressions of Rust after a month of development (check the code [at my GitHub repository](https://github.com/rasendubi/bkernel)).

<!--more-->

## Why Rust?

All started with [Idris](http://www.idris-lang.org/). It has an extremely great type system, especially effects system, so I thought it would be interesting to apply it to operating system development. Unfortunately, Idris requires massive runtime and GC, so it's not an option.

I've explored what new languages suitable for kernel programming are there. I settled on two: [Nim](http://nim-lang.org/) and [Rust](https://www.rust-lang.org/). In fact, I chose Nim because it has simple effects system, optional GC, and [fascinating pragmas](http://nim-lang.org/docs/manual.html#pragmas). I even finished [a hello world kernel in Nim](https://github.com/rasendubi/bkernel/commit/bb8079a5990f0762c0d16b1726a5a1d25b05de0a), but it turned out [Nim's volatile pragma is broken](https://github.com/nim-lang/Nim/issues/3382). End of story---you can't develop a kernel without a volatile (well, you can, but that will turn out deep pain at some point).

So, I'm here developing an operating system in Rust.

## How is it going?

Now I have a basic USART, GPIO and LED drivers, a dumb terminal with a couple of commands, and I'm running on [a real board](http://www.st.com/web/catalog/tools/FM116/SC959/SS1532/PF252419?sc=internet/evalboard/product/252419.jsp). There are a good documentation and tests for most parts, build system, a [Travis](https://travis-ci.org/) setup (though, the latest update to cargo-0.7.0 [broke my documentation generation](https://github.com/rust-lang/cargo/issues/2175), but I'm running nightly---what I expected).

I have a crazy idea for system architecture and want to try it out, but I need a memory allocator first. So that's what I'm working on now. In fact, I've been working on it more than on other parts taken together. It deserves a separate post, and I hope to write it when I finish the allocator.

## What are your impressions of Rust?

I like the language; I like a good type system and the strong emphasis on safety. The generated machine code is well-optimized (yeah, I've looked through it). There are few features I miss, but I hope some will be added in future (feel myself on the front line of future Rust kernel developers).

I want to have more power at compile-time. There are too many things you can't do at compile-time. From top of my head:

- You can't cast a raw pointer to a reference (even when a pointer is a compile-time constant), so I end up writing something like this:

  ```rust
  pub const GPIO_A: Gpio = Gpio(0x40020000 as *const GpioRegister);

  pub struct Gpio(*const GpioRegister);

  impl Deref for Gpio {
      type Target = GpioRegister;

      fn deref(&self) -> &GpioRegister {
          unsafe { &*self.0 }
      }
  }
  ```

  instead of something like:

  ```rust
  pub const GPIO_A: &'static Gpio = 0x40020000 as &'static Gpio;
  ```

  This way, you can use `GPIO_A` as if it were a real reference.

- You can't have a size of type at compile-time.

  Currently, I just call a function every time I need the size of type. That has no performance cost as compiler inlines everything, but that bloats the code and makes it less readable (and less writable as well).

- Ok, there is almost nothing you can do at compile-time.

  There is a [`const_fn` feature](https://github.com/rust-lang/rfcs/blob/master/text/0911-const-fn.md) that should change the game, but it's not quite there yet.

The other minor thing I miss is C's arrow operator. Rust's auto-dereferencing rules don't work for raw pointers, so I end up writing things like `(*prev_block).size += (*block).size` instead of `prev_block.size += block.size` or C's `prev_block->size += block->size`. That's a minor thing, but it annoys when you're dealing with lots of raw pointers.

I haven't expected, but the other annoying thing is strong typing, I have lots of casting back and forth between `usize`, `isize`, and `u16`, and it gets annoying sometimes. I by no means want to change this, just expressing my woes; I still think strong typing is a thing, and I can live with some extra explicit type casts.

## Any strange debug stories?

Yeah, there is one. I had a loop like this:

```rust
let mut command: [u8; 256] = [0; 256];
let mut cur = 0;

let mut c = usart.get_char();
while c != '\r' as u32 {
    command[cur] = c as u8;
    cur += 1;

    if cur == 256 {
        break;
    }

    usart.put_char(c);
    c = usart.get_char();
}
```

That's just a synchronous read of line from a USART char by char. I wanted to add proper handling of backspace, so code became like this:

```rust
let mut command: [u8; 256] = [0; 256];
let mut cur = 0;

let mut c = usart.get_char();
while c != '\r' as u32 {
    if c == 0x8 {
        // TODO: handle backspace
    } else {
        command[cur] = c as u8;
        cur += 1;

        if cur == 256 {
            break;
        }

        usart.put_char(c);
    }

    c = usart.get_char();
}
```

Just wrap a couple of statements in `if`. Now the funny part: that increased the size of the image from 1.5 Kb to 3.5 Kb. Yeah, one extra line of code resulted in 2 additional kbytes of ROM. That's more than all my other code taken together at that moment.

_"What could happen? That's just an innocent line of code. It doesn't do anything!"_, you think. Well, you know Rust inserts a bounds-checking for array accesses. The compiler was smart enough to eliminate them in the first case, but adding a condition broke analysis, so bound-checks got inserted into machine code in the second case.

_"Okay... But wait a minute! A bound check is just a couple of instructions. How they could double the size of the image?"_ Yes, a bound check isn't that expensive, but... in case index is wrong, it calls panic with a message that includes array length and index. That, in turn, requires the code for formatting strings, which takes several kbytes. That was the real reason.

_"Maybe, you could just turn bounds checking off."_ I would be glad, but bounds checking is not optional ([and won't ever be](http://thread.gmane.org/gmane.comp.lang.rust.devel/9133/), as far as I understand). I know about [`get_unchecked_mut`](https://doc.rust-lang.org/std/primitive.slice.html#method.get_unchecked_mut), but a case-wise solution is not an option here: if I ever use a checked indexing, I'll return to the same state. Furthermore, I don't have anything against bound checking itself.

_"Oh... well. What did you do then?"_ I was thinking of [patching libcore](https://internals.rust-lang.org/t/disabling-panic-handling/1834/7) to remove formatting from panicking and fail without any message. I even did this locally, and that restored normal size. But then I though that I'll need a formatting code in future anyway and having error messages is really helpful; so I've implemented proper panic handling instead. That further increased image size to 6 Kb, but that's not a big deal.

## Conclusion and plans

I like Rust; there are rough edges but I see a good trend. I hope to finish my allocator soon and start developing a general framework for drivers and everything.

What was your first Rust project? How did it go?
