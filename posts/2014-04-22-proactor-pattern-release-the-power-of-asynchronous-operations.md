---
title: Proactor Pattern: Release the Power of Asynchronous Operations
author: Alexey Shmalko
tags: pattern
keywords: pattern,proactor,proactor pattern
description: A quick introduction to the proactor pattern.
---

During the study of the [Boost library](http://www.boost.org), I've stumbled on Proactor pattern. This is a design pattern intended to handle I/O operations asynchronously; but let's describe other alternatives first.

Massive web servers should serve a lot of active connections in a short period of time; so, it's important to do this most effectively with a less overhead.

Several well-known methods exist:

- Synchronous
- Synchronous Multi-threading
- Asynchronous

Let's describe them in order.

<!--more-->

### Synchronous model

This model is quite straightforward. The server performs all work in a single thread, sequentially accepting a connection, serving it, blocking for every I/O operation, until the connection closes.

Writing such a server is as easy as ABC. However, it obviously is a poor solution, due to the fact that only one connection can be serviced at a time (i.e. no concurrency). This strategy is not suitable for long-term connections and just slow.

<img style="display: block; margin-left: auto; margin-right: auto" src="/images/proactor_synchronous.png" />

This image shows server activity over time. Grey color represents waiting for I/O, while other colors represent actively serving some request.

### Synchronous Multi-threading model

Threading model is also well-known. Its essence is to create accept-fork loop which will accept every incoming connection and fork a new thread to serve it. Each thread serves connection in a synchronous manner. Thus, an application can take advantage of multiprocessor machines and handle multiple connection simultaneously.

<img style="display: block; margin-left: auto; margin-right: auto" src="/images/proactor_synchronous_threading.png" />

While this method is much better than synchronous one, it still has drawbacks.  The main one is that, as far as waiting for I/O occupies most of the time, application performance will suffer from numerous context switches and forks. The second disadvantage is that threads often require some form of synchronization, so that application will be more complicated; as well as additional time will be spent waiting on semaphores and mutexes.

### Asynchronous model
The Proactor pattern represents an asynchronous model.

The main idea is to avoid the overhead of forking and context switching by using asynchronous operations. Asynchronous operations allows to run I/O operations in the background. In this way, the application is able to perform multiple I/O operations simultaneously and may remain single-threaded at the same time.

<img style="display: block; margin-left: auto; margin-right: auto" src="/images/proactor_asynchronous.png" />

1. The application initiates asynchronous operation with the OS and passes Completion Handler and a reference to the Completion Dispatcher that will be used to notify the application upon completion of the asynchronous operation;
2. Then the application invokes the event loop of the Completion Dispatcher;
3. When any operation completes, Completion Dispatcher will be notified and will call specified Completion Handler;
4. it, in turn, may initiate other asynchronous operations;
5. goto 3.

__Interaction diagram__

![Proactor interaction diagram](/images/proactor_sequence_diagram.png)

### Example

You can find examples in [boost asio documentation](http://www.boost.org/doc/libs/1_55_0/doc/html/boost_asio/examples/cpp11_examples.html#boost_asio.examples.cpp11_examples.chat).

Examples are more complex than possible synchronous multi-threaded solutions. But if you spend some time, you can easily figure out what's going on.

### Conclusion
- Proactor pattern __eliminates fork and context-switch overhead__;
- Furthermore, as far as application is single-threaded, there is __little or no need for thread synchronization__;
- However, it __doesn't limit the number of threads__; the Completion Dispatcher encapsulates the concurrency mechanism, so various concurrency strategies may be implemented including single-threaded and [Thread Pool](http://en.wikipedia.org/wiki/Thread_pool_pattern) solutions.

Like any other design pattern, Proactor has its drawbacks:

- Program __complexity increases__;

    Instead of a linear programming model, you should separate connection handling in number of functions which will set each other as a completion handler for some operation.

- Asynchronous events are __hard to debug__;

    Because all operation are asynchronous, it's hard to track an order of program execution.

### Known usage
- [I/O Completion Ports in Windows NT][icp];
- [The UNIX AIO Family of Asynchronous I/O Operations](http://pubs.opengroup.org/onlinepubs/7908799/xsh/aio.h.html);
- [Asynchronous Procedure Calls in Windows NT][apc];
- [Adaptive Communication Environment (ACE)](http://en.wikipedia.org/wiki/Adaptive_Communication_Environment);
- [Boost.Asio library](http://www.boost.org/doc/libs/release/doc/html/boost_asio/overview/core/async.html)

[icp]: http://msdn.microsoft.com/en-us/library/windows/desktop/aa365198(v=vs.85).aspx
[apc]: http://msdn.microsoft.com/en-us/library/windows/desktop/ms681951(v=vs.85).aspx

### Further reading
- [Wikipedia: Proactor pattern](http://en.wikipedia.org/wiki/Proactor_pattern) for general information.
- [Original paper](http://www.cs.wustl.edu/~schmidt/PDF/proactor.pdf) for detailed description and implementation notes.
