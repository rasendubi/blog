---
title: Haskell: Defaulting Rules
author: Alexey Shmalko
tags: haskell
keywords: haskell,defaulting,defaulting rules
description: What's defaulting in Haskell and how to use it.
---

I've signed for Haskell-cafe mailing list to learn something new a day ago. The first letter I received was asking which [defaulting proposals](https://ghc.haskell.org/trac/haskell-prime/wiki/Defaulting) are actively pursued. I'd knew nothing about defaulting and why it should be improved, so that's what I learned today.

<!--more-->

## What's defaulting and default declaration?

A problem inherent with Haskell type system is the possibility of an *ambiguous type*. It arises when compiler can't determine the concrete type of subexpression from source code. The easiest example of that is:

```haskell
let x = read "..." in show x
```

There is no way for compiler to infer the type of `x`. Any `a` that is an instance of both `Show` and `Read` would satisfy the constraints.

The default way to resolve ambiguities is to explicitly specify the type. For example:

```haskell
let x = read "..." in show (x :: Int)
```

Ambiguities in the class `Num` are most common, so Haskell provides another way to resolve them — defaulting. If compiler can't figure out which instance of `Num` it should choose, it will pick the default one. You'll see the following warning with `-Wall` if that happens:

```
Warning: Defaulting the following constraint(s) to type ‘Integer’
```

You may assume the default instance for `Num` is `Integer`. Almost guessed! I'll tell you the answer a bit later.

Haskell provides a way to select what types compiler should consider as default for `Num` &mdash; *default declaration*.

To specify the list of types, you can write (where all types are instances of `Num`):

```haskell
default (type1, ..., typeN)
```

Compiler will choose the first one that satisfies the constraints.

Only one default declaration is permitted per module, and its effect is limited to that module. The no default declaration is given in a module then it assumed to be:

```haskell
default (Integer, Double)
```

To turn off defaulting, specify empty list:

```haskell
default ()
```

Unfortunately, even if you explicitly specify default types for module, compiler will warn you about defaulting (which can be a pain in the ass with `-Werror`).

## So what's wrong with current rules and what are proposals?

### Problem 1. User-defined classes

The most significant problem is that defaulting rules are applied to `Num` class only. It would be nice to specify defaulting rules for user-defined classes.

Two proposals address this issue. The first one suggest specifying class name before list of defaults. The problem arises when type variable is constrained by two classes with different defaults. For example:

```haskell
default A (Int, String)
default B (String, Int)
(A t, B t) => t
```

What type should compiler choose? I don't know.

The next proposal avoids this kind of problems simply by permitting only one default type per class, rather than a list. In that case, there is only two option: all default types match or they don't.

```haskell
default A Int
default B String
(A t, B t) => t
```

Now it's a failure for sure. And the main cons of this proposal are backward compatibility and lack of way to disable defaulting. The later is easy-fixable by allowing omission of the default type in default declaration.

### Problem 2. Scoping

A default clause applies only within the module containing the declaration. Defaults can be neither exported nor imported.

For me, this problem arises only if problem 1 is resolved. Exporting defaulting rules for you own typeclass in any way is a nice feature to have.

Currently, the single proposal addressing this issue is to make all defaulting rules global.

I believe it's not the best option. I'd like to have local defaulting rules with the possibility of explicit exporting.

### Problem 3. Defaulting

The last proposal is the most radical one: remove defaulting altogether. It's motivated by the fact that it's generally agreed that defaulting, in its current form at least, is a wart on the language.

It also proposes to change signature of `(^)` and introduce `genericPower` (because the `^` is the most frequent cause of defaulting):

```haskell
(^)          :: (Num a) => a -> Int -> a
genericPower :: (Num a, Integral b) => a -> b -> a
```

It also expect interactive environments to continue default values.

Personally, I'd like to write `sum [1..100]` and get `5050` instead of error.

## Further reading

- [Ambiguous Types, and Defaults for Overloaded Numeric Operations](https://www.haskell.org/onlinereport/decls.html#sect4.3.4) in the Haskell 98 Report.
- [Defaulting proposals](https://ghc.haskell.org/trac/haskell-prime/wiki/Defaulting)
