---
title: Git: Working in Detached HEAD
author: Alexey Shmalko
tags: git
keywords: git,detached,head
description: How to work in detached HEAD in your everyday work.
---
At work, we use a [rebase-based git workflow](http://unethicalblogger.com/2010/04/02/a-rebase-based-workflow.html) to keep master history plain along with [gerrit](https://code.google.com/p/gerrit/) to track multiple versions of the same commit and code review. This implies doing a lot of commit juggling including fetching individual commits from gerrit, checking out back and forth, rebasing and cherry-picking. I found myself in the detached HEAD state pretty often. I used to create a new branch or force update old one and checkout on it. Then I gradually started to do a part of work in detached HEAD and then realized these branches only hinder me in most cases; so now before beginning work on a new feature I'm not creating a new branch but rather checking out straight into detached HEAD.

I know this may be a unidiomatic git, but that's how things work for me. Even though I work with detached HEAD, most commands here are equally useful with branches. You can also adopt working in detached HEAD with you current workflow (e.g. work in detached HEAD only for small tasks).
<!--more-->

## Preparing

This has nothing to do with detached HEAD but you need a git shell prompt like [this one](https://github.com/olivierverdier/zsh-git-prompt "Informative git prompt for zsh") first. This is not strictly necessary but your git life will be much easier with one. Otherwise, you risk losing commit you're working on or doing right things with the wrong commit.

## Start work on feature

To begin work on new task execute:

```bash
git checkout master # or whatever commit your work should base
git checkout --detach # as a bonus, you don't have to come up with the new branch name
```

We're in detached HEAD now. Congratulations!

## Checking out from gerrit

In a case of your work should be based on gerrit patch or you just need to work with one, gerrit generates git command for checking out. Just select `checkout` in Download section on patch page and copy-paste command in your terminal. It'll look like this:

```bash
git fetch ssh://user@host:port/project refs/changes/12/3456/7 && git checkout FETCH_HEAD
```

You're in detached HEAD now. No need to create a new branch or doing anything special. Just go to next section.

## Doing work

Work, as usual, commit new changes with `git commit`, amend with `git commit --amend`. Nothing special here.

## Rebasing on master

Before pushing your changes, you want to rebase on latest master. You can do this with the following commands:

```zsh
git checkout master # Don't worry, you haven't lost all your work yet
git pull
git checkout - # You're safe again
git rebase master
```

The trick here is `git checkout -`. The magical `-` says git to checkout to the last branch/commit (basically, `-` is synonymous to `@{-1}`). This works pretty much the same way as `cd -`.

When you're done, push your changes to gerrit with `git push origin HEAD:refs/publish/master` (or whichever alias you're using).

## Rebasing on top of new gerrit patch set

To rebase your work on top of arbitrary gerrit patch set execute the following commands:

```bash
git fetch ssh://user@host:port/project refs/changes/12/3456/7 # You don't need to checkout on fetched commit
git rebase -i FETCH_HEAD
```

## How to get distracted

You often have to checkout to a different commit and do some quick task. For example, someone asked you to test code, or Jenkins build fails and you want to do a quick fix. In cases you know you won't do more than one checkout---just do it; you'll be able to return to current commit with `git checkout -`. For example:

```bash
git fetch ssh://user@host:port/project refs/changes/12/3456/7 && git checkout FETCH_HEAD

vim # Fix/test whatever you want
git add blah-blah
git commit --amend
git push origin HEAD:refs/publish/master

git checkout -
```

That's all. Now you can continue working on your task.

## Switching between task

In case you know working on the second task will take a substantial amount of time you probably need take action to not lose your results. Usually, switching means you're done with current task (at least for now) and uploaded patch set to gerrit (at least draft one). In this case it's safe to leave the current commit---you can always find it again on gerrit.

In case there is no patchset on gerrit, just create branch after all ;)

And how do you guys optimize your work with git?
