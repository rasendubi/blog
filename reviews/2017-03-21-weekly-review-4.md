---
title: Weekly Review 2017 Week 11
author: Alexey Shmalko
tags: review
keywords: review
---

My fourth weekly review. (Has been delayed for a day due to sleep deprivation.)

This week:

- Easy and straightforward password manager.
- Downloading patches from GitHub.
- Programming in Emacs Lisp.
- Linear typing in Haskell.

<!--more-->

## Management

Some articles on delegation. (I should definetely delegate more.)

- **[Грабли при делегировании, на которые я наступила](https://m.habrahabr.ru/post/317986/)**
- **[Delegation as Art](http://queue.acm.org/detail.cfm?id=2926696)**

## Ansible

- **[My experience of using NixOps as an Ansible user](https://blog.wearewizards.io/my-experience-of-using-nixops-as-an-ansible-user)**
- **[How Ansible Works](https://www.ansible.com/how-ansible-works)**

## Emacs

- **[Living in Evil](https://blog.aaronbieber.com/2016/01/23/living-in-evil.html)**
- **[Emergency Elisp](http://steve-yegge.blogspot.com/2008/01/emergency-elisp.html)**

### Emailing

I [continue](/2017/weekly-review-3/) reading about different email setups in Emacs. Though, I have finally settled on mbsync + dovecot + gnus.

- **[MailLocation/Maildir](https://wiki2.dovecot.org/MailLocation/Maildir)**
- **[Geek: How to use offlineimap and the dovecot mail server to read your Gmail in Emacs efficiently](http://sachachua.com/blog/2008/05/geek-how-to-use-offlineimap-and-the-dovecot-mail-server-to-read-your-gmail-in-emacs-efficiently/)**
- **[EmacsWiki: Gnus Speed](https://www.emacswiki.org/emacs/GnusSpeed)**
- **[MailServerOverview - Dovecot Wiki](https://wiki2.dovecot.org/MailServerOverview)**
- **[dimitri/mbsync-el: Wrap calling mbsync in Emacs Lisp, with a gnus hook](https://github.com/dimitri/mbsync-el)**. I call mbsync from gnus [now](https://github.com/rasendubi/dotfiles/commit/f483db6cdd959130b443ef6d10b22a3004894ddb).
- **[Leaving Gmail Behind](http://nullprogram.com/blog/2013/09/03/)**
- **[Mutt with multiple accounts, mbsync, notmuch, GPG and sub-minute updates](https://lukespear.co.uk/mutt-multiple-accounts-mbsync-notmuch-gpg-and-sub-minute-updates)**
- **[Practical guide to use Gnus with Gmail](https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/gnus-guide-en.org)**
- **[Emacs, Notmuch and Offlineimap](http://chrisdone.com/posts/emacs-mail)**
- **[Migrating from offlineimap to mbsync for mu4e](http://pragmaticemacs.com/emacs/migrating-from-offlineimap-to-mbsync-for-mu4e/)**
- **[How I email, 2016 edition](http://deferred.io/2016/01/18/how-i-email.html)**

### Programming in Emacs Lisp

I have remembered I have started reading [Programming in Emacs Lisp](https://www.gnu.org/software/emacs/manual/eintr-formats.html) some time ago, and decided to continue reading.

- **[6. Narrowing & Widening](https://www.gnu.org/software/emacs/manual/html_node/eintr/Narrowing-_0026-Widening.html)**
- **[7. car cdr & cons](https://www.gnu.org/software/emacs/manual/html_node/eintr/car-cdr-_0026-cons.html)**

## (Still) Exploring ES6

I continue my reading. I have read the chapter I have skipped [before](/2017/weekly-review-3/) but that's pretty much all for this week.

- **[12. Callable entities in ECMAScript 6](http://exploringjs.com/es6/ch_callables.html)**

## Security

- **[Pass: The Standard Unix Password Manager](https://www.passwordstore.org/)**. A nice and easy password manager I have started using. I have finally replaced my password with very long random ones ^\_^
- **[Tomb :: File Encryption on GNU/Linux](https://www.dyne.org/software/tomb/)**
- **[Hash-based message authentication code - Wikipedia](https://en.wikipedia.org/wiki/Hash-based_message_authentication_code)**
- **[HMAC-based One-time Password Algorithm - Wikipedia](https://en.wikipedia.org/wiki/HMAC-based_One-time_Password_Algorithm)**. (pass is able to store OTP passwords via [pass-otp](https://github.com/tadfisher/pass-otp).)
- **[Did NSA Put a Secret Backdoor in New Encryption Standard](https://www.schneier.com/essays/archives/2007/11/did_nsa_put_a_secret.html)**. Nice reading to make you think about security standards.

## Git

- **[Code Archaeology with Git](http://jfire.io/blog/2012/03/07/code-archaeology-with-git/)**. How to explore your git history to get facts you want.
- **[Ten Things You Didn’t Know Git And GitHub Could Do](https://owenou.com/ten-things-you-didnt-know-git-and-github-could-do)**. Nothing new about git, but nice GitHub tricks. (Keyboard shortcuts, getting raw diffs.)

## Programming languages design

- **[Linear types make performance more predictable](http://blog.tweag.io/posts/2017-03-13-linear-types.html)**. Adding linear types to Haskell.
- **[The Dark Path](http://blog.cleancoder.com/uncle-bob/2017/01/11/TheDarkPath.html)**. Kotlin/Swift critique. I can't agree as I love strict typing and it saved me lots of pain.
