---
title: Weekly Review 2017 Week 13
author: Alexey Shmalko
tags: review
keywords: review
---

This is my sixth review.

This week:

- diving in Rust futures
- encrypting hard drive
- don't waste the time wiping your hard drive in multiple passes
- Managing for People Who Hate Managing

<!--more-->

## Rust

- **[Выпуск Rust 1.16](https://habrahabr.ru/post/324448/)**. What's new in Rust 1.16.
- **[rfcs/1236-stabilize-catch-panic.md at master · rust-lang/rfcs](https://github.com/rust-lang/rfcs/blob/master/text/1236-stabilize-catch-panic.md)**. Allow catching unwind panics, so it is possible to prevent thread crashing. That is useful for worker pools, and to cross borders between languages. (Stabilized as [std::panic::catch_unwind()](https://doc.rust-lang.org/std/panic/fn.catch_unwind.html).)
- **[std::panic::UnwindSafe - Rust](https://doc.rust-lang.org/nightly/std/panic/trait.UnwindSafe.html)**. Related to the previous link. This marker trait is used to assert the type is "panic safe."
- **[Resurrecting impl Trait](http://aturon.github.io/blog/2015/09/28/impl-trait/)**. A review of the [old `impl Trait` proposal](https://github.com/rust-lang/rfcs/pull/105).

### Futures

[Rust futures](https://github.com/alexcrichton/futures-rs) are cool. I have an idea to port them to an embedded platform, or at least use them extensively. So far I'm just studying sources.

- **[Expanding the Tokio project](http://aturon.github.io/blog/2016/08/26/tokio/)**
- **[Designing futures for Rust](http://aturon.github.io/blog/2016/09/07/futures-design/)**. This one is must read.
- **[futures::future::Future - Rust](https://docs.rs/futures/0.1.11/futures/future/trait.Future.html)**
- **[std::thread - Rust](https://doc.rust-lang.org/std/thread/index.html)**
- **[epoll - Linux manual page](http://man7.org/linux/man-pages/man7/epoll.7.html)**

## Nix

- **[Installation of NixOS with encrypted root](https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134)**. I have a NixOS on encrypted hard drive now \\o/
- **[Typing nix : Let's type nix !](https://typing-nix.regnat.ovh/posts/lets-type-nix.html)**

## Security

- **[Secure deletion: a single overwrite will do it](https://web.archive.org/web/20120102004746/http://www.h-online.com/newsticker/news/item/Secure-deletion-a-single-overwrite-will-do-it-739699.html)**. A single overwrite of the data with zeros is good enough to protect your data. More passes are mostly a waste of time.
- **[Frequently Asked Questions · Wiki · cryptsetup](https://gitlab.com/cryptsetup/cryptsetup/wikis/FrequentlyAskedQuestions)**. A good FAQ about hard drive encryption, LUKS, and encryption in general.
- **[Publishing My Private Keys](http://nullprogram.com/blog/2012/06/24/)**. As you know, GPG private key is encrypted with the key passphrase. This article describes adjusting GPG private key encryption settings to increase the key decryption time to the point it is OK to publish the private key.
- **[Diceware Passphrases](http://nullprogram.com/blog/2009/02/07/)**. A method of easy-to-remember, easy-to-type, secure passphrase and password generation.

## Programming in Emacs Lisp

I continue reading _Programming in Emacs Lisp_, though it comes slowly.

- **[8. Cutting & Storing Text](https://www.gnu.org/software/emacs/manual/html_node/eintr/Cutting-_0026-Storing-Text.html)**

## Misc

- **[Google Open Source Blog: Operation Rosehub](https://opensource.googleblog.com/2017/03/operation-rosehub.html)**. Patching thousands open source projects to fix a vulnerability.
- **[Visual Studio Code отнимает 13% ресурсов CPU из-за мерцания курсора](https://geektimes.ru/post/287342/)**. A funny bug that caused 13% CPU load for cursor blinking.
- **[Когда появится следующий большой язык программирования с точки зрения Дарвина](https://habrahabr.ru/company/wrike/blog/323550/)**. Darwin theory applied to programming languages.
- **[How can I mount a filesystem, mapping userids?](http://unix.stackexchange.com/questions/158678/how-can-i-mount-a-filesystem-mapping-userids)** Mount volumes, mapping uids and gids. It was useful for backing up data from old hard drive.
  ```
  bindfs --map=1002/rasen:@1002/@users /mnt/home /mnt/home2
  ```
- **[You Should Work Less Hours—Darwin Did](http://m.nautil.us/issue/46/balance/darwin-was-a-slacker-and-you-should-be-too)**. I should consider resting more :)

## Offline reading

### Managing for People Who Hate Managing

I have finished reading [Managing for People Who Hate Managing: Be a Success By Being Yourself](https://www.amazon.com/Managing-People-Who-Hate-Yourself/dp/1609945735) by Devora Zack. The book is very fun to read.

The book mostly addresses people communication and ignores project planning, etc. As far as I see, the main idea is applying [MBTI (Myers-Briggs Type Indicator)](https://en.wikipedia.org/wiki/Myers%E2%80%93Briggs_Type_Indicator) to management. You should not treat others as you would want them to treat you, but treat them as they want to be treated. Different people require different approaches. (e.g., thinking types prefer getting to the business directly and hate small talks, while feeling types prefer other way around.)

The ideas are familiar to me as I've been digging into [Socionics](https://en.wikipedia.org/wiki/Socionics) (an alternative theory of personality type) for quite some time.
