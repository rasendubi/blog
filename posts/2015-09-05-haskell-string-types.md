---
title: Haskell String Types
author: Alexey Shmalko
tags: haskell,strings
---

The goal of this blog post is to ease the confusion of Haskell string types. I assume you already know what `String` is, so I'll only cover the difference between string types and help to build intuition on what type you should choose for the task in hand.

<!--more-->

## String

As you all know, `String` is just a type synonym for list of `Char`s:

```haskell
type String = [Char]
```

This is good because you can use all functions for list manipulations on `String`s. The bad news is that storing such strings implies massive overhead, [up to 4 words per character](https://wiki.haskell.org/GHC/Memory_Footprint) and size of `Char` itself is 2 words. This also strikes speed.

To see why overhead is so high, check [slide 43](http://image.slidesharecdn.com/slides-100930074853-phpapp01/95/highperformance-haskell-43-728.jpg) from Johan Tibell's [High-Performance Haskell](http://www.slideshare.net/tibbe/highperformance-haskell) presentation.

That's why we have `ByteString`.

## ByteString

The [`bytestring`](http://hackage.haskell.org/package/bytestring) package provides an efficient compact, immutable byte string type. The [`Data.ByteString.ByteString`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString.html#t:ByteString) type keeps the string as a single large array. That's really fast and memory efficient. Furthermore, it's convenient for passing data between C and Haskell. The downside is that it forces whole string to be in memory at the same time, which negates lazy I/O (when you call [`readFile`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString.html#v:readFile), it reads whole file in the memory before starting processing).

For that reason, the library contains second string type: [`Data.ByteString.Lazy.ByteString`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html#t:ByteString). It uses a lazy list of strict chunks, so this type is suitable for I/O streaming.

You can think of lazy bytestring as `[Data.ByteString.ByteString]`. In fact there are [`toChunks`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html#v:toChunks) and [`fromChunks`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html#v:fromChunks) functions that convert lazy bytestring to/from a list of strict bytestrings.

To convert between `String` and `Data.ByteString.ByteString` types, use [`Data.ByteString.pack`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString.html#v:pack) and [`Data.ByteString.unpack`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString.html#v:unpack) functions. There are same functions for lazy bytestrings in `Data.ByteString.Lazy` module.

***Note:*** calling `pack` on Unicode strings will truncate character codes and you definetely don't want this. You should use [`fromString`](https://hackage.haskell.org/package/utf8-string/docs/Data-ByteString-UTF8.html#v:fromString) and [`toString`](https://hackage.haskell.org/package/utf8-string/docs/Data-ByteString-UTF8.html#v:toString) functions from [`utf8-string`](https://hackage.haskell.org/package/utf8-string) module instead.

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

To convert between strict and lazy bytestrings use [`fromStrict`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html#v:fromStrict) and [`toStrict`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html#v:toStrict) from [`Data.ByteString.Lazy`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html) module.

[`Data.ByteString`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString.html) and [`Data.ByteString.Lazy`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy.html) modules implement many convenient functions and mimic the list interface. However, these modules treat string as a list of `Word8`. If you want to use bytestring as a list of `Char`s, you should use [`Data.ByteString.Char8`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Char8.html) and [`Data.ByteString.Lazy.Char8`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Lazy-Char8.html) modules.

***Note:*** You may be confused that you have a new [`Data.ByteString.Char8.ByteString`](http://hackage.haskell.org/package/bytestring/docs/Data-ByteString-Char8.html#t:ByteString) type now and you don't know how to convert `Data.ByteString.ByteString` to `Data.ByteString.Char8.ByteString`. Don't worry! This is the same type, it's just re-exported from two modules.

The final note on bytestrings: the library isn't designed for Unicode. For Unicode strings you should use `Text` from `text` package.

## Text

It's easier to handle [`text`](http://hackage.haskell.org/package/text) package after `bytestring` one, so I'll be short here.

`text` package was designed specifically for Unicode. It's a bit slower than `bytestring` but still much faster than plain `String`. It comes in both strict and lazy variants in [`Data.Text`](http://hackage.haskell.org/package/text/docs/Data-Text.html) and [`Data.Text.Lazy`](http://hackage.haskell.org/package/text/docs/Data-Text-Lazy.html) modules.

To convert between `String` and `text` strings you can use `pack` and `unpack` functions. To convert between `text` and `bytestring` use encoding functions from [`Data.Text.Encoding`](http://hackage.haskell.org/package/text/docs/Data-Text-Encoding.html) or [`Data.Text.Lazy.Encoding`](http://hackage.haskell.org/package/text/docs/Data-Text-Lazy-Encoding.html).

## OverloadedStrings

You may often need to create string literals of different types. One possible solution is to use functions to convert `String` to the type you need. For example:

```haskell
Prelude> import qualified Data.ByteString.Char8 as BS
Prelude BS> BS.pack "hello"
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

Choose `ByteString` for lots of I/O, serialization or parsing.

Choose `Text` for Unicode text processing.

That's basically all you should know to start working with strings.


### Further reading

- [`bytestring`](http://hackage.haskell.org/package/bytestring) library;
- [`utf8-string`](https://hackage.haskell.org/package/utf8-string) library;
- [`text`](https://hackage.haskell.org/package/text) library;
- [`text-icu`](http://hackage.haskell.org/package/text-icu) library for more Unicode features, encodings, normalization and regular expressions;
- [`ListLike`](http://hackage.haskell.org/package/ListLike) package for common interface to all strings.

### Appendix A. Conversion table
In case you forgot how to convert between types, here is a table of conversions:
<!--TODO insert links to functions-->
<table>
\   <tr><th>from \\ to</th><th>String</th></tr>
\   <tr><td>Data.ByteString</td><td>`Data.ByteString.unpack` / `Data.ByteString.UTF8.toString`</td></tr>
\   <tr><td>Data.ByteString.Lazy</td><td>`Data.ByteString.Lazy.unpack` / `Data.ByteString.Lazy.UTF8.toString`</td></tr>
\   <tr><td>Data.Text</td><td>`Data.Text.unpack`</td></tr>
\   <tr><td>Data.Text.Lazy</td><td>`Data.Text.Lazy.unpack`</td></tr>


\   <tr><th>from \\ to</th><th>Data.ByteString</th></tr>
\   <tr><td>String</td><td>`Data.ByteString.pack` / `Data.ByteString.UTF8.fromString`</td></tr>
\   <tr><td>Data.ByteString.Lazy</td><td>`Data.ByteString.Lazy.toStrict`</td></tr>
\   <tr><td>Data.Text</td><td>`Data.Text.Encoding.encodeUtf8`</td></tr>


\   <tr><th>from \\ to</th><th>Data.ByteString.Lazy</th></tr>
\   <tr><td>String</td><td>`Data.ByteString.Lazy.pack` / `Data.ByteString.UTF8.toString`</td></tr>
\   <tr><td>Data.ByteString</td><td>`Data.ByteString.Lazy.fromStrict`</td></tr>
\   <tr><td>Data.Text.Lazy</td><td>`Data.Text.Lazy.Encoding.encodeUtf8`</td></tr>


\   <tr><th>from \\ to</th><th>Data.Text</th></tr>
\   <tr><td>String</td><td>`Data.Text.pack`</td></tr>
\   <tr><td>Data.ByteString</td><td>`Data.Text.Encoding.decodeUtf8`</td></tr>
\   <tr><td>Data.Text.Lazy</td><td>`Data.Text.Lazy.toStrict`</td></tr>


\   <tr><th>from \\ to</th><th>Data.Text.Lazy</th></tr>
\   <tr><td>String</td><td>`Data.Text.Lazy.pack`</td></tr>
\   <tr><td>Data.ByteString.Lazy</td><td>`Data.Text.Lazy.Encoding.decodeUtf8`</td></tr>
\   <tr><td>Data.Text</td><td>`Data.Text.Lazy.fromStrict`</td></tr>
</table>
