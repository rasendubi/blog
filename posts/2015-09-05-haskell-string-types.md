---
title: Haskell String Types
author: Alexey Shmalko
tags: haskell,strings
keywords: haskell,string,text,bytestring
description: Describes the difference and motivation between Haskell's String, Text, and ByteString types.
---

The goal of this blog post is to ease the confusion of Haskell string types. I assume you already know what `String` is, so I'll only cover the difference between string types and help to build intuition on what type you should choose for the task in hand.

<!--more-->

***Note:*** It's a second edition of the blog post. You can find the first one on [github](https://github.com/rasendubi/blog/blob/2c52a3ed541c8a8a0b514b66816fd03d92919f7c/posts/2015-09-05-haskell-string-types.md) 

## String

As you all know, `String` is just a type synonym for list of `Char`s:

```haskell
type String = [Char]
```

This is good because you can use all functions for list manipulations on `String`s. The bad news is that storing such strings implies massive overhead, [up to 4 words per character](https://wiki.haskell.org/GHC/Memory_Footprint) and size of `Char` itself is 2 words. This also strikes speed.

To see why overhead is so high, check [slide 43](http://image.slidesharecdn.com/slides-100930074853-phpapp01/95/highperformance-haskell-43-728.jpg) from Johan Tibell's [High-Performance Haskell](http://www.slideshare.net/tibbe/highperformance-haskell) presentation.

That's why we have `Text`.

## Text

[`text`][text] package provides an efficient packed Unicode text type. Internally, the [`Text`][Data.Text.Text] type is represented as an array of `Word16` UTF-16 code units. The overhead for storing a string is 6 words.

To convert between `String` and `Text` you can use [`pack`][Data.Text.pack] and [`unpack`][Data.Text.unpack] from [`Data.Text`][Data.Text] module.

The [`Data.Text`][Data.Text] module also provides many functions to work with `Text` and mimics the list interface. It also provides a full-string [case conversion][text case conversion] functions (`map toUpper` doesn't work for Unicode because result could have different length). The module is intended to be imported qualified. There are also I/O functions in [`Data.Text.IO`][Data.Text.IO] module.

The downside of storing the string in a strict array is that way it forces the whole string to be in memory at the same time, which negates lazy I/O (when you call [`readFile`][Data.Text.IO.readFile], it reads whole file in the memory before starting processing). That's why the library provides the second string type: [`Data.Text.Lazy.Text`][Data.Text.Lazy.Text]. It uses a lazy list of strict chunks, so this type is suitable for I/O streaming.

You can think of lazy `Text` as `[Data.Text.Text]`. In fact there are [`toChunks`][Data.Text.Lazy.toChunks] and [`fromChunks`][Data.Text.Lazy.fromChunks] functions that convert lazy `Text` to/from a list of strict `Text`.

The [`Data.Text.Lazy`][Data.Text.Lazy] module copies the interface of `Data.Text` module but for lazy `Text`. To convert between strict and lazy `Text`, use [`toStrict`][Data.Text.Lazy.toStrict] and [`fromStrict`][Data.Text.Lazy.fromStrict] functions.

[text]: http://hackage.haskell.org/package/text
[Data.Text.pack]: http://hackage.haskell.org/package/text/docs/Data-Text.html#v:pack
[Data.Text.unpack]: http://hackage.haskell.org/package/text/docs/Data-Text.html#v:unpack
[Data.Text]: http://hackage.haskell.org/package/text/docs/Data-Text.html
[Data.Text.Text]: http://hackage.haskell.org/package/text/docs/Data-Text.html#t:Text
[text case conversion]: http://hackage.haskell.org/package/text-1.2.1.3/docs/Data-Text.html#g:8
[Data.Text.IO]: http://hackage.haskell.org/package/text/docs/Data-Text-IO.html
[Data.Text.IO.readFile]: http://hackage.haskell.org/package/text/docs/Data-Text-IO.html#v:readFile
[Data.Text.Lazy]: http://hackage.haskell.org/package/text/docs/Data-Text-Lazy.html
[Data.Text.Lazy.Text]: http://hackage.haskell.org/package/text/docs/Data-Text-Lazy.html#t:Text
[Data.Text.Lazy.toChunks]: http://hackage.haskell.org/package/text/docs/Data-Text-Lazy.html#v:toChunks
[Data.Text.Lazy.fromChunks]: http://hackage.haskell.org/package/text/docs/Data-Text-Lazy.html#v:fromChunks
[Data.Text.Lazy.toStrict]: http://hackage.haskell.org/package/text/docs/Data-Text-Lazy.html#v:toStrict
[Data.Text.Lazy.fromStrict]: http://hackage.haskell.org/package/text/docs/Data-Text-Lazy.html#v:fromStrict

## ByteString

There is also a type you will see often called `ByteString`. The funny thing is that it's not intended to be a string. The `ByteString` type is an array of bytes that comes in both strict and lazy forms; it's really good for serialization and passing data between C and Haskell. It may be a bit faster than `Text` for some operations because `Text` does more work to handle Unicode properly.

Generally, you shouldn't use this type for text manipulation as it doesn't support Unicode. But you should know how to deal with `ByteString`s because it's *de facto* standard type for networking, serialization and parsing in Haskell.

The standard view into `ByteString` types represent elements as `Word8`. [`Data.ByteString`][Data.ByteString] and [`Data.ByteString.Lazy`][Data.ByteString.Lazy] modules provide functions that mimic `[Word8]` interface.

It's also possible to treat bytes as a Latin-1 encoded string. [`Data.ByteString.Char8`][Data.ByteString.Char8] and [`Data.ByteString.Lazy.Char8`][Data.ByteString.Lazy.Char8] modules re-export the same bytestring types (so you don't need to convert between `Data.ByteString.ByteString` and `Data.ByteString.Char8.ByteString` types) and provide functions to see `ByteString` as a list of `Char`s.

But you should be cautious because truncating is possible. For example, calling [`pack`][Data.ByteString.Char8.pack] on Unicode strings will truncate character codes and you definetely don't want this. You should use [`fromString`](https://hackage.haskell.org/package/utf8-string/docs/Data-ByteString-UTF8.html#v:fromString) and [`toString`](https://hackage.haskell.org/package/utf8-string/docs/Data-ByteString-UTF8.html#v:toString) functions from [`utf8-string`](https://hackage.haskell.org/package/utf8-string) module instead.

```haskell
Prelude> import qualified Data.ByteString.Char8 as BS
Prelude BS> import qualified Data.ByteString.UTF8 as BU
Prelude BS BU> BS.putStrLn (BS.pack "hello")
hello
Prelude BS BU> BS.putStrLn (BS.pack "привет")
?@825B
Prelude BS BU> BS.putStrLn (BU.fromString "привет")
привет
Prelude BS BU> putStrLn (BS.unpack (BU.fromString "привет"))
Ð¿ÑÐ¸Ð²ÐµÑ
Prelude BS BU> putStrLn (BU.toString (BU.fromString "привет"))
привет
```

The [`Data.Text.Encoding`][Data.Text.Encoding] module provides functions for encoding/decoding `Text` to `ByteString`.

[Data.ByteString]: http://hackage.haskell.org/package/bytestring/docs/Data-ByteString.html
[Data.ByteString.Lazy]: http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html
[Data.ByteString.Char8]: http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Char8.html
[Data.ByteString.Lazy.Char8]:http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy-Char8.html
[Data.ByteString.Char8.pack]: http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Char8.html#v:pack
[Data.Text.Encoding]: http://hackage.haskell.org/package/text/docs/Data-Text-Encoding.html

## OverloadedStrings

You may often need to create string literals of different types. One possible solution is to use functions to convert `String` literal to the type you need. For example:

```haskell
Prelude> import qualified Data.Text as T
Prelude T> T.pack "hello"
"hello"
```

But that's really tiresome to type all these conversion functions all over again, especially when number of strings in the code is high.

The other possible solution is to enable `OverloadedStrings` language pragma. You can place `{-# LANGUAGE OverloadedStrings #-}` in your source code to start.

Let's check what it does in ghci:

```haskell
Prelude> :t "hello"
"hello" :: [Char]
Prelude> :set -XOverloadedStrings
Prelude> :t "hello"
"hello" :: Data.String.IsString a => a
```

As you see, this changes the type of string literals to `Data.String.IsString a => a`.

The definition of [`IsString`](http://hackage.haskell.org/package/base/docs/Data-String.html#t:IsString) typeclass is simple:

```haskell
class IsString a where
    fromString :: String -> a
```

`fromString` defines a function to convert `String` to the given type. What `OverloadedStrings` really does is replaces `"hello"` with `fromString "hello"`. There are instances of `IsString` for all string types we just covered, so you can use usual `"hello"` as if it was a bytestring or a text.

```haskell
Prelude> import qualified Data.ByteString.Char8 as BS
Prelude BS> import qualified Data.Text.IO as T
Prelude BS T> :set -XOverloadedStrings
Prelude BS T> putStrLn "hello"
hello
Prelude BS T> BS.putStrLn "hello"
hello
Prelude BS T> T.putStrLn "hello"
hello
```

## Conclusion

Choose `String` when you don't care about performance or strings are small (e.g. identifiers).

Choose `Text` for general text processing.

Choose `ByteString` for storing raw bytes, serialization or parsing.

That's basically all you should know to start working with strings.

### Further reading

- [`text`](https://hackage.haskell.org/package/text) library;
- [`text-icu`](http://hackage.haskell.org/package/text-icu) library for more Unicode features, encodings, normalization and regular expressions;
- [`bytestring`](http://hackage.haskell.org/package/bytestring) library;
- [`utf8-string`](https://hackage.haskell.org/package/utf8-string) library;
- [`ListLike`](http://hackage.haskell.org/package/ListLike) package for common interface to all strings.
