---
title: Using Vim as C/C++ IDE
author: Alexey Shmalko
tags: C, clang, Vim
keywords: vim,ide,c,c++,java,clang,configuration
description: How to turn Vim into a powerful C/C++ IDE.
---

I'm an embedded operating system developer and I do all my development tasks solely in the terminal. 

The main tool, which helps me to accomplish this, is vim. Today, I will describe how to turn vim into a powerful IDE for C/C++ projects. I will not recommend you any plugin for project management, since vanilla vim already has all the power to cope with this task.

Despite the fact that I use vim as a C IDE, the part of following recommendations are pretty general and may be used to any kind of project.

<!--more-->

# Prerequirements #
First of all, you want to enable <b>exrc</b> option. This option forces vim to source .vimrc file if it present in working directory, thus providing a place to store project-specific configuration.

Since vim will source .vimrc from any directory you run vim from, this is a potential security hole; so, you should consider to set <b>secure</b> option. This option will restrict usage of some commands in non-default .vimrc files; commands that write to file or execute shell commands are not allowed and map commands are displayed.

So, you should add these two lines to your main .vimrc file.

	set exrc
	set secure

# Project-specific options #
After you managed to store vim settings on per-directory basis, you should place all your project-specific settings in .vimrc file at top directory of your project.

First of all, you want to set indentation rules for your project (I suppose, your project has kind of style guide).
	
	set tabstop=4
	set softtabstop=4
	set shiftwidth=4
	set noexpandtab

I also try to keep my lines 110 chars at most. But I don't trust vim such an important task as line breaking, because it depends on context too much. So, the thing I want is to see exactly how much space is left, so I highlight column number 110 with color.

	set colorcolumn=110
	highlight ColorColumn ctermbg=darkgray

# File-type detection #
By default, vim assumes all .h files to be C++ files. However, I work with pure C and want filetype to be c. Since project also comes with doxygen documentation, I want to set subtype to doxygen to enable very nice doxygen highlighting.

Add lines like these to your local .vimrc file:

```
augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup END
```

# Setting path variable #
Vim has an <b>gf</b> command (and related, \<C-W>\<C-F> to open in new tab) which open file whose name is under or after the cursor. This feature is extremely useful for browsing header files.

By default, vim searches file in working directory. However, most projects have separated directory for include files. Thus, you should set vim's <b>path</b> option to contain comma-separated list of directories to look for the file.

	let &path.="src/include,/usr/include/AL,"

### Note ###
Java users should pay attention to <b>includeexpr</b> option. It contains expression which will be used to transform string to a file name. The following line changes all "." to "/" for <b>gf</b> command (and related):

	set includeexpr=substitute(v:fname,'\\.','/','g')

# Autocomplete #
~~The best~~ (Outdated. Now I use YouCompleteMe. See [my post](/2014/youcompleteme-ultimate-autocomplete-plugin-for-vim/) for details) Good autocomplete plugin for C/C++ language I found is a [clang\_complete](https://github.com/Rip-Rip/clang_complete) (refer to plugin page for installation instructions).

It uses clang to generate list of suggestions and works fine for both C and C++.

In order to let clang know about your include directories custom defines, you should place your `-I` and `-D` compiler flags into .clang_complete file at the root of your project.

### Tip ###
If you already populated <b>path</b> option with include directories, you may use following command to insert list of compiler options:

	"='-I'.substitute(&path, ',', '\n-I', 'g')<cr>p

(After that, you should review generated list for inconsistency, because it's okay to put several commas in row or end line with one in <b>path</b> option)

# Project drawer #
To display a project tree, you can use either custom plugins ([NERD Tree](https://github.com/scrooloose/nerdtree)), or built-in netrw plugin.

I don't use any of them as project drawer, because I'm pretty comfortable with selecting files directly from command mode.

[One interesting article about project drawer and vim.](http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/)

# Configure build system #
After you're done with file editing and navigation, you want to configure vim to easily build your project. Vim has a <b>make</b> command which, by default, executes make in current directory and parses output for errors.

The actual command to execute is stored in <b>makeprg</b> option. If you build your project out of source, with custom make arguments or even a different build command, just change <b>makeprg</b> to reflect this.

	set makeprg=make\ -C\ ../build\ -j9

After that, you can build your project as easily as typing ":make". You may want to go further and bind this command to one of keys. For example:

	nnoremap <F4> :make!<cr>

(`!` mark prevents vim from jumping to location of first error found)

# Configure launch system #
After you build your project, it's expected to run it. You can execute any shell command from vim's command mode if you prepend it with `!`. So, to run your great program you just type `:!./my_great_program`.

Of course, you want to bind it to something simpler:

	nnoremap <F5> :!./my_great_program<cr>

# Version control support #
Since vim provides access to the shell, I don't actually use any special plugin for this task and manage git tree completely from the shell.

But I should mention that there are powerful vim plugins for version control systems. For exmaple, [fugitive](https://github.com/tpope/vim-fugitive). If you work with git, you absolutely must look at [fugitive vimcasts](http://vimcasts.org/episodes/fugitive-vim---a-complement-to-command-line-git/).

# Conclusion #
After a couple of simple operations, we added and uncovered a lot of vim features and built a completely Integrated Development Environment.

I would be really happy to hear how you integrated you tools together. So, go ahead and drop down a comment.
