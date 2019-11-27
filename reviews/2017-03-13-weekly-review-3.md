---
title: Weekly Review 2017 Week 10
author: Alexey Shmalko
tags: review
keywords: review
---

This is my third weekly review.

This week:

- Still Exploring JS.
- Baking an email client out of Emacs.

<!--more-->

## Emacs

The top topic of this week is making a mail client out of emacs! I probably haven't saved all web pages I've read on the topic. (There are no saved pages on notmuch, which is nice and easy option, which I had set up.)

I haven't finished my setup yet, but when I do, that's a good topic to post about.

Some discussions of available options on reddit/google groups.

- **[Email in emacs, I want to, but wow, it's overwhelming](https://www.reddit.com/r/emacs/comments/4rl0a9/email_in_emacs_i_want_to_but_wow_its_overwhelming/)**
- **[Which email client (mu4e, Mutt, notmuch, Gnus) do you use inside Emacs, and why?](https://www.reddit.com/r/emacs/comments/3s5fas/which_email_client_mu4e_mutt_notmuch_gnus_do_you/)**
- **[gnus --> mu4e/notmuch](https://groups.google.com/forum/#!topic/mu-discuss/Z1NvRflnGT4)**

[This comment](https://www.reddit.com/r/emacs/comments/4rl0a9/email_in_emacs_i_want_to_but_wow_its_overwhelming/d52q08p/?st=j07hlgag&sh=1cee46f5) describes the whole landscape of the problem. The mail idea to remember is that you need (1) something to fetch your email, (2) something send email, and (3) something to view your email.

For (1), you most likely want mbsync.

For (2), you can go with either msmtp or emacs built-in smtp support. The former is more powerful.

\(3) is the most diverse vector. Top three most popular solutions seem to be gnus, mu4e, and notmuch.

### Mbsync / offlineimap

This is how you fetch email into your box. From the comments all around, mbsync is superior. (In case you wonder, isync is the name of the project, mbsync is the name of the executable.)

- **[Bloerg: Syncing mails with mbsync (instead of OfflineIMAP)](https://bloerg.net/2013/10/09/syncing-mails-with-mbsync-instead-of-offlineimap.html)**
- **[Mails, moving from offlineimap to mbsync (isync)](http://blog.tshirtman.fr/2014/3/12/mails-moving-from-offlineimap-to-mbsync-isync)**
- **[OfflineIMAP sucks](http://blog.ezyang.com/2012/08/offlineimap-sucks/)**
- **[isync - ArchWiki](https://wiki.archlinux.org/index.php/Isync)**

### Gnus

I have also tried notmuch and it's nice, but its interfaces makes browsing through new messages a bit slower (from usage perspective, implementation is pretty fast).

- **[What's wrong with Gnus](https://www.rath.org/whats-wrong-with-gnus.html)**
- **[EmacsWiki: Gnus Tutorial](https://www.emacswiki.org/emacs/GnusTutorial)**. A decent tutorial.
- **[Gnus Manual: Mail Source Specifiers](https://www.gnu.org/software/emacs/manual/html_node/gnus/Mail-Source-Specifiers.html)**
- **[Multiple GMail Accounts in Gnus](http://www.cataclysmicmutation.com/2010/11/multiple-gmail-accounts-in-gnus)**
- **[Re: How to add multiple email accounts inside gnus](https://lists.gnu.org/archive/html/help-gnu-emacs/2015-11/msg00031.html)**
- **[kensanata/ggg: Gmail, Gnus and GPG](https://github.com/kensanata/ggg)**. The main thing is to learn how to encrypt/sign your mail. (Use `mml-secure-message-sign/encrypt-pgpmime` in the mail compose mode.)

## Cryptography / GPG

One of emacs mail disscussions led me to GPG critique.

- **[GPG And Me](https://moxie.org/blog/gpg-and-me/)**
- **[Inline PGP in E-mail is bad, Mm'kay?](https://josefsson.org/inline-openpgp-considered-harmful.html)**
- **[Advanced cryptographic ratcheting](https://whispersystems.org/blog/advanced-ratcheting/)**

## JavaScript

### Exploring ES6

I keep reading Exploring ES6 at my lazy time. This week I read next chapters:

- **[9. Variables and scoping](http://exploringjs.com/es6/ch_variables.html)**
- **[10. Destructuring](http://exploringjs.com/es6/ch_destructuring.html)**
- **[11. Parameter handling](http://exploringjs.com/es6/ch_parameter-handling.html)**
- **[13. Arrow functions](http://exploringjs.com/es6/ch_arrow-functions.html)**

Yeah... I've skipped 12 because it's huge, but I'm catching up.

### React

- **[Share Code between React and React Apps](https://hackernoon.com/code-reuse-using-higher-order-hoc-and-stateless-functional-components-in-react-and-react-native-6eeb503c665)**
- **[acdlite/recompose: A React utility belt for function components and higher-order components.](https://github.com/acdlite/recompose)**
- **[Our Best Practices for Writing React Components](https://medium.com/code-life/our-best-practices-for-writing-react-components-dec3eb5c3fc8)**

## Misc

This week I have also set up Jenkins and Hydra for continuous integration, but there are no full-blown articles on the topic I've read.

- **[bringing NIX to its limits](https://invalidmagic.wordpress.com/2011/02/14/bringing-nix-to-its-limits/)**. Running Nix on Windows.
- **[Hydra manual](https://nixos.org/hydra/manual/)**. I've made a quick setup of Hydra to test my project at work.
- **[Зачем нужен Refresh Token, если есть Access Token?](https://habrahabr.ru/company/Voximplant/blog/323160/)**
- **[Разработка игр на Rust. Моя история](https://habrahabr.ru/post/323120/)**
