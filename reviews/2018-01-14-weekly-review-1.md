---
title: Weekly Review 2018 Weeks 1–2
author: Alexey Shmalko
tags: review
keywords: review
---

This is my first weekly review in this year. (And first one after a long pause.)

These two weeks:

- 8,760 hours
- Meltdown and Spectre
- You don't have to be that busy
- Sleeping well

<!--more-->

Total articles read: 25

## Productivity

- **[8,760 hours](https://drive.google.com/file/d/0B2PaeRjVqAN7MngxTXFPQkpLVjg/view)**. Absolutely awesome.

- **[A Lack of Time is a Lack of Priorities](https://alexvermeer.com/a-lack-of-time-is-a-lack-of-priorities/)**.

  The idea here is that _you_ can really control how _busy_ you are. Most of the task you think you have to complete are not mandatory in reality. Next time you find yourself busy, stop and think if you really want to do all the tasks.

- **[Sleeping well](http://mindingourway.com/sleeping-well/)**

  - always get enough sleep
  - wake up at fixed time (which shifts with daylight time, though)
  - use light to get up
  - don't sleep in after long night
  - compensate with naps
  - learn to nap properly

- **[If You Don’t Want To Regret Your Life 30 Years Later, Make This One Choice Right Now](https://medium.com/the-mission/if-you-dont-want-to-regret-your-life-30-years-later-make-this-one-choice-right-now-1cc137516df0)**.

  Why you focus on short-term goals instead of long-term ones.

## Emacs

- **[My Workflow with Org-Agenda](http://cachestocaches.com/2016/9/my-workflow-org-agenda/)**
- **[A Baby Steps Guide to Managing Your Tasks with Org](http://emacslife.com/baby-steps-org.html)**

## Security

- **[В Gmail обнаружена уязвимость, позволяющая блокировать чужие учетные записи](https://tproger.ru/news/gmail-vulnerability-blocked-user-accounts/)**

### Meltdown and Spectre

- **[Finding a CPU Design Bug in the Xbox 360](https://randomascii.wordpress.com/2018/01/07/finding-a-cpu-design-bug-in-the-xbox-360/)**. While not really about Meltdown/Spectre, but describes finding of a similar bug in Xbox 360 CPU.
- **[Intel CEO Krzanich sold shares after company was informed of chip flaw](http://www.businessinsider.com/intel-ceo-krzanich-sold-shares-after-company-was-informed-of-chip-flaw-2018-1)**

## React / Web development

- **[React Stateless Functional Components: Nine Wins You Might Have Overlooked](https://hackernoon.com/react-stateless-functional-components-nine-wins-you-might-have-overlooked-997b0d933dbc)**
- **[The Top 66 Developer Resources From 2017](https://hackernoon.com/the-top-66-developer-resources-from-2017-e82531365e6d)**. Not exactly about web development but mostly about it.

## Misc

- **[To Serve Man, with Software](https://blog.codinghorror.com/to-serve-man-with-software/)**
- **[go channels are bad and you should feel bad](http://www.jtolds.com/writing/2016/03/go-channels-are-bad-and-you-should-feel-bad/)**

  In short:

  - go channels have bad API (throw panics, non-symmetric)
  - channels block (which makes them hard to use with mutexes and other traditional synchronization primitives)
  - not powerful enough

  This also reminded me of Haskell, which also has M:N scheduling and is much nicer. (as a bonus, Haskell's GC detects endlessly blocked channels)

- **[What Color is Your Function?](http://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/)**

  A post about asynchronous programming, async-await, generators and green threads. (Green threads been the best.)

  The post does not mention Haskell, but it has green threads, too.

- **[A 5-second fix might make your Chrome browser much smoother](http://bgr.com/2016/03/18/fix-slow-chrome-browser-scrolling-lag/)**

  Go to [chrome://flags/#smooth-scrolling](chrome://flags/#smooth-scrolling) and disable smooth scrolling feature.

  Well, this does not _fix_ my lag, but made it less frequent

- **[Lessons from the impl period](http://smallcultfollowing.com/babysteps/blog/2018/01/05/lessons-from-the-impl-period/)**

  Rust compiler team has structured the year to include an "implementation period," when they particularly focus on compiler implementation. Here are some notes on what worked well and what didn't. In particular, focusing working groups on goals rather than compiler parts is a nice idea I like.
