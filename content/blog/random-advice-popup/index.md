---
title: Random Advice Popup
author: Alexey Shmalko
tags: cron, popup, tips
keywords: tips,advice,popup,cron
description: Display random advice every hour
date: 2014-05-06
---

A long time ago, I had read a book [The Pragmatic Programmer: From Journeyman to Master](http://pragprog.com/the-pragmatic-programmer) (if someone didn't read it yet, I highly recommend it). This book is a collection of extremely useful tips for programmers. But this post is not about the book.

Recently I decided to revisit these tips again; and found that I don't remember some of them. So that, I decided to create something that will regularly remind me of them. The best choice was on-screen popups showing one tip at a time.

<!--more-->

![random advice](random-advice-popup.png)

The pros are:

- it's fairly easy to create on-screen popup;
- it doesn't require some action from me; so, I can miss it if I so wish.

### Implementation

I create [the following shell script](random-advice.sh) and make it executable:

```bash
#!/bin/sh
export DISPLAY=:0
CAPTION="Random advice"
PHRASES=/home/rasen/phrases.txt
cat "$PHRASES" | sed '/^$/d' | sort -R | head -1 | tr -d '\n' | xargs -0 notify-send "$CAPTION"
```

This script takes one random line from specified file and displays it in popup.

Let's examine script one piece at a time:

1. `export DISPLAY=:0` is for displaying notifications from cron job;
2. `sed '/^$/d'` removes empty lines;
3. `sort -R | head -1` extracts one random line;
4. `tr -d '\n'` removes trailing newline;
5. `xargs -0 notify-send "$CAPTION"` displays final line inside the on-screen notification.

### Running script regularly

After that, I executed `crontab -e` and created user cron job by adding the following line:

```cron
0 * * * * /home/rasen/random-advice.sh
```

That's a cron rule to run specified script every hour.

After that, a popup will appear every hour displaying one tip.

#### Other option

If you don't have or don't want to utilize cron, you are free to select any alternative that will execute the script at given interval.

For example, you may run the script manually inside the infinite loop:

```shell
while true ;do
    sleep 3600 && ~/random-advice.sh
done
```

As another alternative, you may use [systemd's events](https://wiki.archlinux.org/index.php/Systemd/cron_functionality) (remember to run the script under your user).

Bonus: [Pragmatic Programmer tips in the text file](pragmatic-programmer.txt)
