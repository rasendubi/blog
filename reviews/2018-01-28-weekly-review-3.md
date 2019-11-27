---
title: Weekly Review 2018 Week 4
author: Alexey Shmalko
tags: review
keywords: review
---

This week:

- Plain Text Accounting
- Screencast recording

<!--more-->

Total articles read: 12

## Accounting

I've been much into accounting this week. Especially plain text and double-entry accounting.

I got most of my bank excerpts imported into [hledger](http://hledger.org/).
Before, I had imported banking SMS and processed them with a custom Python script, but hledger gave me much more power in analysing my expenses.

I also configured hledger to track shared expenses and automatically split shares, so I finally know how to—and started to—handle family finances with my girlfriend.

### [Plain Text Accounting](http://plaintextaccounting.org/)

The main idea of plain text accounting is to store all financial data in plain text file format (pretty geeky).
The other part is [double-entry accounting](https://en.wikipedia.org/wiki/Double-entry_bookkeeping_system) (pretty simple—all transactions must sum up to zero (balance); no money appears out of nowhere and comes into nowhere).
The plain text idea and file format was pioneered by [ledger](https://www.ledger-cli.org/) and numerous clones exist.
[hledger](http://hledger.org/) is a ledger clone written in Haskell.

[plaintextaccounting.org](http://plaintextaccounting.org/) contains more info on the topic.

Here is main info I read this week:

- **[hledger: step-by-step](http://hledger.org/step-by-step.html)**
- **[hledger: guide](http://hledger.org/guide.html)**
- **[hledger: journal](http://hledger.org/journal.html)**
- **[howto: shared expenses](https://mumble.net/~campbell/2017/02/26/ledger/HOWTO-sharedexpense)**

  A general idea of how to track shared expenses. While it's simplistic and does not handle cases when some expenses are non-shared, it gives a general idea which can be adapted further.

- **[hledger/budget-rewrite.sh at 8eb77dce2bd651ccc8b4203f8176bae05f6d3f6c · simonmichael/hledger](https://github.com/simonmichael/hledger/blob/8eb77dce2bd651ccc8b4203f8176bae05f6d3f6c/bin/budget-rewrite.sh)**

  hledger does not currently handle automatic transaction inside the journals. (It could not parse my automatic rules.) This link gives an example of using `hledger-rewrite` to emulate the behavior (i.e., semi-automatic transactions).

  (In my distribution, `hledger-rewrite` command is not available and `hledger rewrite` subcommand must be used.)

### General accounting

- **[The Millionaire Next Door - Wikipedia](https://en.wikipedia.org/wiki/The_Millionaire_Next_Door)**

  This page contains an overview of "The Millionaire Next Door" book.

  The main idea is UAW/PAW term (Under Accumulator of Wealth).

  It is interesting to know in general, though I believe the formula does not work for young people as it expects you to accumulate wealth along all your lifetime. (Which can't be true while you have almost no income in first ~15 years of your life.)

- **[I Need A Budget](https://www.barrucadu.co.uk/posts/etc/2017-12-16-i-need-a-budget.html)**
- **[Ask the Readers: I've Tracked My Expenses -- Now What?](http://www.getrichslowly.org/2011/04/08/ask-the-readers-ive-tracked-my-expenses-now-what/)**
- **[Track every penny you spend ~ Get Rich Slowly](http://www.getrichslowly.org/2006/09/22/track-every-penny-you-spend/)**

## Screen recording

I recorded a short screencast for my friend this week.

I used [screenkey](https://www.thregr.org/~wavexx/software/screenkey/) and/or [key-mon](https://code.google.com/archive/p/key-mon/) to show your key presses.

- **[Linux screen recorder, screencasting with FFmpeg](https://www.pcsuggest.com/linux-screen-recorder-ffmpeg/)**

  Record your desktop with:

  ```sh
  ffmpeg -f x11grab  -s 3200x1800 -i :0.0 -r 25 -vcodec libx264 output.mkv
  ```

  Use the following command to detect your screen size:

  ```sh
  xrandr -q --current | grep '*' | awk '{print$1}'
  ```
