---
title: IO is Your Command Pattern
author: Alexey Shmalko
tags: haskell
keywords: haskell,io,command,pattern
description: How to understand IO if you know command pattern.
---

In this post I'll try to give some intuition behind IO in Haskell for people who know what [command pattern](https://en.wikipedia.org/wiki/Command_pattern) is, without explaining what [M-word](https://wiki.haskell.org/Monad) or [do-notation](https://en.wikibooks.org/wiki/Haskell/do_notation) is.

<!--more-->

First, let's revisit command pattern. According to [wiki](https://en.wikipedia.org/wiki/Command_pattern):

> In [object-oriented programming](https://en.wikipedia.org/wiki/Object-oriented_programming), the **command pattern** is a [behavioral](https://en.wikipedia.org/wiki/Behavioral_pattern) [design pattern](https://en.wikipedia.org/wiki/Software_design_pattern) in which object is used to [encapsulate](https://en.wikipedia.org/wiki/Information_hiding) all information needed to perform an action or trigger an event at a later time. This information includes the method name, the object that owns the method and values for the method parameters.

Let's implement the pattern in Java:

```java
interface Command {
    void execute();
}
```

`Command` is an interface for implementing different commands. It has method `execute` that triggers command execution. Pretty simple.


But let's extended the interface and allow return values.


```java
interface Command<T> {
    T execute();
}
```

This allows to define commands that return values, such as `GetLine` (remember `getLine :: IO String` in Haskell).

```java
class GetLine implements Command<String> {
    public String execute() {
        Scanner scanner = new Scanner(System.in);
        return scanner.nextLine();
    }
}
```

Now you should see how `IO String` in Haskell is similar to `Command<String>`.

Let's implement `PutStrLn` now. The Haskell analog is `putStrLn :: String -> IO ()`, that is a function that takes a `String` and returns a command that prints that string to the console. The proper Java interface for such a thing is `Function<String, Command<Void>>` (from [`java.util.function`](https://docs.oracle.com/javase/8/docs/api/java/util/function/Function.html)).

```java
class PutStrLn implements Function<String, Command<Void>> {
    public Command<Void> apply(String str) {
        return () -> { System.out.print(str); return null; };
    }
}
```

We can use it like this:
```java
new PutStrLn().apply("Hello, world!").execute();
```

(you see how execution stage is separated from command creation?)

Now the fun begins. Let's add a couple of methods for combining our `Command`s:

```java
public interface Command<T> {
    T execute();

    static <T> Command<T> pure(T value) {
        return () -> value;
    }

    default <U> Command<U> then(Command<U> next) {
        return () -> {
            this.execute();
            return next.execute();
        };
    }

    default <U> Command<U> bind(Function<T, Command<U>> that) {
        return () -> that.apply(this.execute()).execute();
    }
}
```

`pure` is a simple method that creates new `Command` which, when executed, returns given value. This method is the same as Haskell's `return :: a -> IO a` function.

`then` takes additional command and returns a new command which, when executed, executes `this` command and then executes the second command and return its result. This method is Haskell's `(>>) :: IO a -> IO b -> IO b`.

`bind` takes a function from `T` to a new command and return a command which, when executed, executes the `this` command and passes its result to the function and executes final command. This function is Haskell's `(>>=) :: IO a -> (a -> IO b) -> IO b`.

Let's write a "real-world" application with that.

```java
class Main {
    static Function<String, Command<String>> ask = (String prompt) ->
        new PutStrLn().apply(prompt).then(
        new GetLine());

    static Command<Integer> cmd =
        ask.apply("What's your name? ").bind((String name) ->
        ask.apply("What's your birth year? ").bind((String year) ->
        new PutStrLn().apply("Hello, " + name + ". You should be " +
            (2015 - Integer.parseInt(year)) + " years old now.").then(
        Command.pure(2015 - Integer.parseInt(year)))));

    public static void main(String[] args) {
        Integer age = cmd.execute();
    }
}
```

`ask` is a helper function (command) that asks the user for some info and returns user's answer.

The same program in Haskell:
```haskell
ask :: String -> IO String
ask prompt = putStrLn prompt >> getLine

main :: IO Integer
main =
    ask "What's your name?" >>= \name ->
    ask "What's your birth year?" >>= \year ->
    putStrLn ("Hello, " ++ name ++ ". You should be " ++
        show (2015 - read year) ++ " years old now.") >>
    return (2015 - read year)
```

But Haskell can do better!

```haskell
ask :: String -> IO String
ask prompt = do
    putStrLn prompt
    getLine

main :: IO Integer
main = do
    name <- ask "What's your name?"
    year <- ask "What's your birth year?"
    putStrLn ("Hello, " ++ name ++ ". You should be " ++
        show (2015 - read year) ++ " years old now.")
    return (2015 - read year)
```

Haskell has a special [do-notation](https://en.wikibooks.org/wiki/Haskell/do_notation). In fact, it's just a syntactic sugar for `>>`, `>>=` and lambdas. So the last program is the same as previous one.

Now you should notice that the whole Haskell program is one big command and there is no `execute` in Haskell &mdash; all programs should be composed of primitive commands provided by the base library.

That's how Haskell keeps things pure. Think! Your whole program is just a command &mdash; a recipe that describes what program should do. `putStrLn` is a pure(!) function that returns command (which in turn knows what to print on screen). `getLine` is a constant(!) value &mdash; a command; you're not performing I/O when you type `name <- getLine`.

## Conclusion

- IO is a free command pattern in Haskell; you can pass `IO` values around as any other values.
- All functions in Haskell are pure;
- `do` is not a hack for doing I/O; it's just a syntactic sugar;

*P.S. Note that `>>`, `>>=`, `return` and do-notation are not unique to `IO` and I lied about their types. They all work for any [Monad](https://wiki.haskell.org/Monad), not just `IO`.*
