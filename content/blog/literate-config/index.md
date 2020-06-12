---
title: "4 Years with Literate Configuration"
author: Alexey Shmalko
date: "2020-06-12T23:08+0300"
---

I store all my configuration files in an open [dotfiles] repository.

It [started with a 74-line `.vimrc` file][first-version] in 2013.
Since then, it has grown enormously, and today includes configuration for my whole system for three hosts, including full OS configuration, custom scripts, and [4k-line Emacs configuration][emacs-configuration].
The configuration is so complete that I can wipe my drive and restore the system in an hour.

Dealing with a ton of configuration files---even without publishing them openly---is a lot of work, and can get unmanageable quickly.

Tools that help me do that without losing my sanity are [NixOS], [Home Manager], and [Org-mode] ([org-babel]).

NixOS allows managing operating system configuration using a single file.
Home Manager extends that concept to applications and settings that usually live in the home directory.

But today I want to talk about Org-mode and Literate Configuration.

This post is not a tutorial but rather my impression after using this setup for four years now.

[dotfiles]: https://github.com/rasendubi/dotfiles
[first-version]: https://github.com/rasendubi/dotfiles/commit/a564ca55803706c5f2f01e9e9fc6da1396d1c4b3#diff-9f2717ecb7c66e36c9654b48424ae983
[emacs-configuration]: https://github.com/rasendubi/dotfiles/blob/34a0ff79678a1a10f6796e2e826537c096b081fd/emacs.org
[NixOS]: https://nixos.org/
[Home Manager]: https://github.com/rycee/home-manager
[Org-mode]: https://orgmode.org/
[org-babel]: https://orgmode.org/worg/org-contrib/babel/

<!--more-->

## What works well

### Decoupling

Literate configuration allows to decouple organization of configuration from actual files the settings ends up in.
It allows keeping related parts close together---even if they belong to different files on disk.

As an example, I use [mbsync], [msmtp], and [notmuch] to deal with email load.
These are separate applications with their own configuration files, but logically they are coupled---adding a new email address requires changing all three configurations.
Org-mode allows keeping all three configurations in a single file, which are then *tangled* (exported) to their respective locations.

[mbsync]: http://isync.sourceforge.net/
[msmtp]: https://marlam.de/msmtp/
[notmuch]: https://notmuchmail.org/

This decoupling ability is not limited to separate files, though---you can reorganize and reorder parts of a single file.

An example is my NixOS configuration to install Emacs and its plugins.

Using simplified pseudo-code, the main fragment looks like this ([real code is here][real-code]):
```nix
{
  description = "rasendubi's NixOS configuration";

  inputs = {
    <<flake-inputs>> # highlight-line
  };

  outputs = inputs: {
    nixosConfigurations.omicron = {
      <<nixos-section>> # highlight-line
    };

    packages = {
      <<flake-packages>> # highlight-line
    };

    overlays = [
      <<flake-overlays>> # highlight-line
    ];
  };
}
```

[real-code]: https://github.com/rasendubi/dotfiles/blob/34a0ff79678a1a10f6796e2e826537c096b081fd/README.org#flake

Highlighted lines allow me to define inputs, configurations, packages, and overlays in other places.

Now for Emacs, I can write a single section that modifies all these parts:
```org
** Emacs

Add emacs-overlay flake input with fresh nightlies.

#+name: flake-inputs
#+begin_src nix
emacs-overlay = {
  type = "github";
  owner = "nix-community";
  repo = "emacs-overlay";
};
#+end_src

Install overlay.

#+name: flake-overlays
#+begin_src nix
inputs.emacs-overlay.overlay
#+end_src

Expose my Emacs for anyone who wants to get it without the whole NixOS system.

#+name: flake-packages
#+begin_src nix
my-emacs =
  (pkgs.emacsPackagesGen pkgs.emacs)
    .emacsWithPackages
      (epkgs: with epkgs.melpaPackages; [
        use-package
        ...
      ]);
#+end_src

Install Emacs with my packages.

#+name: nixos-section
#+begin_src nix
services.emacs = {
  enable = true;
  defaultEditor = true;
  package = inputs.self.packages.my-emacs;
};
#+end_src
```

### Folding

<!-- Because configuration now is an org-mode file, I can use all goodies (todos, links, formatting). -->

Org-mode has good folding support.
Folding means my 4k-line Emacs configuration looks like this:
```org
* Configuration infrastructure…
* EXWM…
* Evil…
* General…
* Org-mode…
* Languages…
* Mail setup…
* Workman…
* Look and feel…
```

Each section has more subsections---that makes configuration manageable so that I can go with a single configuration file.

### Atomicity

Because a single section can configure multiple parts, sections are self-contained---you don't have to look at other sections to understand what the current one is doing.

Sections can be organized based on what I'm trying to achieve or what problem I am solving.

Atomic sections are easier to share.
You have an issue with xbacklight not working? I would send you a link to my [Screen brightness] section.

```org
** Screen brightness

~xbacklight~ stopped working recently. ~acpilight~ is a drop-in replacement.
#+name: nixos-section
#+begin_src nix
{
  hardware.acpilight.enable = true;
  environment.systemPackages = [
    pkgs.acpilight
  ];
  users.extraUsers.rasen.extraGroups = [ "video" ];
}
#+end_src

For Home Manager–managed hosts:
#+name: home-manager-section
#+begin_src nix
{
  home.packages = [pkgs.acpilight];
}
#+end_src
```

It's a small section, but it shows how to get screen brightness working: install `acpilight` *and* add yourself to the `video` group. (It also shows how to do that for both NixOS and Home Manager.)

[Screen brightness]: https://github.com/rasendubi/dotfiles/blob/34a0ff79678a1a10f6796e2e826537c096b081fd/README.org#screen-brightness

As a bonus, self-contained sections are easier to ditch---delete the section, and both acpilight and video group are gone.

### Granularity

Technically, I can achieve the same decoupling and atomicity by splitting NixOS configurations into multiple files. 

However, Org sections are much easier to create and work with.
This results in me having more small sections.

Would I create a separate section for screen brightness if I didn't use org? Unlikely---I would probably just plug it into a larger "X configuration" file.

## Caveats

This setup is not without drawbacks.

### Prose

The central proposition of literate programming is that it makes programs understandable by weaving them with prose/documentation.

The thing is, I don't actually read my prose---I don't need to.

Is it even useful for other people? I don't know really.

Nevertheless, prose---as any documentation---needs to be maintained. If you change section, you need to make sure the prose is updated accordingly.

### Complexity

Literate programming introduces an additional layer of indirection, and indirection means complexity.
You can't just fork my configuration and start tweaking it.

If you want to understand how to tangle and build the system from an org file, you have to wrap your head around the whole setup.

[org-patches]: https://github.com/rasendubi/dotfiles/blob/34a0ff79678a1a10f6796e2e826537c096b081fd/emacs.org#patch-ob-tangle
[emacs-bootstrap]: https://github.com/rasendubi/dotfiles/blob/34a0ff79678a1a10f6796e2e826537c096b081fd/emacs.org#bootstrap

### Display

If you view my configuration files outside of Emacs, you have a harder time.

GitHub doesn't have folding and doesn't show a table of content. That makes it impossible to get an overview of the system.

GitHub also does not show headers for code blocks. When you see a code block on GitHub, you don't see its name or file it tangles to.

This also makes the system harder to understand.

## Summary

I like my configuration---for me, pros outweigh cons.

Now that [Emacs is my WM][EXWM], I even consider merging NixOS and Emacs configurations into a single file. That makes sense because my NixOS configuration is incomplete.
For example, it shows that I use slock and xss-lock, but it does not show *how*---you have to look at Emacs configuration for that.
The same goes for email setup: NixOS files show how to configure applications, but the main interface is notmuch mode in Emacs.

[EXWM]: https://github.com/rasendubi/dotfiles/commit/34a0ff79678a1a10f6796e2e826537c096b081fd

That being said, I can only judge from the author's perspective.
I don't know how it looks from the outside? how do people perceive it when they see it the first time? is it easy to find interesting sections?

