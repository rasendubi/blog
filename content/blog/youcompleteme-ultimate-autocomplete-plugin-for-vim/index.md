---
title: YouCompleteMe — Ultimate Autocomplete Plugin for Vim
author: Alexey Shmalko
tags: autocomplete, clang, UltiSnips, Vim, YouCompleteMe
keywords: autocomplete,auto-complete,vim,c,c++,obj-c,objective-c,c#,python,ruby,php,ide,ycm,youcompleteme,you complete me,ultisnips,.ycm_extra_conf.py,ycm extra conf,tab,conflict
description: Learn how to install and configure YouCompleteMe for Vim.
date: 2014-04-07
---

I've used the [clang_complete](http://https://github.com/Rip-Rip/clang_complete 'clang_complete') plugin to autocomplete my C code for five months... until YouCompleteMe caught my eye. And now I feel that would stay with it indefinitely.

<!--more-->

## Quick overview

[YouCompleteMe (YCM)](https://github.com/Valloric/YouCompleteMe 'YouCompleteMe') is a fast, as-you-type code completion engine for Vim. It combines and prioritizes the output from several sources:

- An identifier-based engine that works with every programming language;
- A semantic, Clang-based engine that provides native semantic code completion for C/C++/Objective-C/Objective-C++ (from now on referred to as "the C-family languages");
- A Jedi-based completion engine for Python;
- An OmniSharp-based completion engine for C#
- An omnifunc-based completer that uses data from Vim's omnicomplete system to provide semantic completions for many other languages (Ruby, PHP, etc.).

![](ycm.gif)

Note that it's not necessary to press any keyboard shortcut to invoke a completion menu.

The second advantage of YCM is that it has a client-server architecture. Vim part of YCM is just a thin client that talks to ycmd server. The server is automatically started and stopped as you start and stop Vim. Thus, YCM doesn't make Vim more sluggish or somehow slow down text editing.

The third significant thing is diagnostic display feature (the little red X that shows up the left gutter) if you are editing a C-family file. As Clang compiles your file and detects warnings and errors, they will be presented in various ways. You don't need to save your file or press any keyboard shortcut to trigger this, it "just happens" in the background.

YCM also provides semantic go-to-definition/declaration commands for C-family languages and Python.

For the more detailed feature overview, visit an [YCM home page](http://valloric.github.io/YouCompleteMe/ 'YouCompleteMe home page').

## Installation

**Edit:** Install instruction changed a bit since this post was published. For full and up-to-date install instructions refer to the [documentation](https://github.com/Valloric/YouCompleteMe/blob/master/README.md#installation).

Installation is pretty straightforward if you use [pathogen](https://github.com/tpope/vim-pathogen 'pathogen'):

```bash
cd ~/.vim/bundle
git clone https://github.com/Valloric/YouCompleteMe.git
cd YouCompleteMe
git submodule update --init --recursive
./install.sh --clang-completer
```

For me YCM server crashed with its own libclang, so I reinstall YCM with system libclang. Just replace `./install.sh --clang-completer` with `./install.sh --clang-completer --system-clang`

## Default auto-completion for C family

To auto-complete source code for C family, you should provide custom _.ycm_extra_conf.py_ file for your project. If you don't do this, YCM will be unable to use semantic completion.

I often write small testing programs right in my temporary directory, naming them 1.c, 2.c, etc. In order to enable semantic autocompletion for every c file, I provide a default _.ycm_extra_conf.py_.

First, add following line to your _.vimrc_:

```vim
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
```

You should replace ~/.vim/.ycm_extra_conf.py with path to your default file.

After that, you should place some content to your extra conf. (Use [my config](https://github.com/rasendubi/dotfiles/blob/master/.vim/.ycm_extra_conf.py) as a template if you don't want to bother with this)

## YouCompleteMe and UltiSnips

Default YouCompleteMe conflicts with default [UltiSnips](https://github.com/SirVer/ultisnips 'UtliSnips') tab key usage. Both YouCompleteMe and UltiSnips suggest map UltiSnips expand trigger to a different key, but I found this unsatisfactory. Rather than using a different key for UltiSnips it's better to make YCM not use Tab key. To do this, add two following lines to your _.vimrc_:

```vim
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
```

Don't worry, you still be able to cycle through completion with **\<C-N>** and **\<C-P>** keys.

## Conclusion

YouCompleteMe provides _a lot_ of features, so it's clear that I stuck with it for a long time.
