---
title: Weekly Review 2017 Week 12
author: Alexey Shmalko
tags: review
keywords: review
---
My fifth weekly review.

This week:

- Green threads without per-thread stack and heap allocations that compile down to state machines.
- C++ template programming is very much like programming in Lisp (modulo parenthesis).
- Use your Control as Escape.
- JSON Schemas.
- Managing for people who hate to manage.

<!--more-->

## Rust
- **[Rust: The ? operator](https://m4rw3r.github.io/rust-questionmark-operator)**. Just a shorter version of `try!` macro.
- **[rfcs/0000-remove-runtime.md at remove-runtime](https://github.com/aturon/rfcs/blob/remove-runtime/active/0000-remove-runtime.md)**

### Tokio
[Tokio](https://tokio.rs/) is a platform for writing fast networking code with Rust. It's awesome: green threads without per-thread stack and heap allocations that compile down to state machines.

I won't quote the table of contents, so just start here:

- **[What is Tokio?](https://tokio.rs/docs/getting-started/tokio/)**

Most fascinating parts are:

- **[The futures model in depth](https://tokio.rs/docs/going-deeper/futures-model/)**
- **[Low-level I/O using core](https://tokio.rs/docs/going-deeper/core-low-level/)**
- **[Tasks and executors](https://tokio.rs/docs/going-deeper/tasks/)**

## Misc
- **[Modern C++ and Lisp Programming Style](https://chriskohlhepp.wordpress.com/advanced-c-lisp/convergence-of-modern-cplusplus-and-lisp/)**. How C++ template programming is similar to programming in Lisp. (Also, Lisp optimization settings changed my mind about Lisps performance.)

- **[alols/xcape: Linux utility to configure modifier keys to act as other keys when pressed and released on their own](https://github.com/alols/xcape)**. Make your Control key another Escape. (Have you already swapped Control with Caps Lock?)

- **[dabbrev - How to make Company mode be case-sensitive on plain Text?](http://emacs.stackexchange.com/questions/10837/how-to-make-company-mode-be-case-sensitive-on-plain-text)**. Fix case for autocompletion in comments: `(setq company-dabbrev-downcase nil)`.

- **[The eigenvector of "Why we moved from language X to language Y"](https://erikbern.com/2017/03/15/the-eigenvector-of-why-we-moved-from-language-x-to-language-y.html)**. Some fun analytics. Though, I don't trust it as it does not take into account that people may not change the language. Also, there is no correction on number of users of languages.

- **[Understanding JSON Schema](https://spacetelescope.github.io/understanding-json-schema/)**. A quick guide into JSON Schema. Useful if you need to write one.

- **[Java и Docker: это должен знать каждый](https://habrahabr.ru/company/ruvds/blog/324756/)**. The main point is that `-m` docker's option only limits the maximum allowed memory for an application (the application still able to check all available memory on the machine). That causes troubles when an application allocates memory as a percent of all available memory.

## Offline reading
I have bought a couple of management books and started reading [Managing for People Who Hate Managing](https://www.amazon.com/Managing-People-Who-Hate-Yourself/dp/1609945735) by Devora Zack. Half of the book is already behind, and it was extremely funny and enjoyable to read.
