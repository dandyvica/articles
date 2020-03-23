---
title: Using threads on Rust (part 1)
published: true
description: How to use threads on Rust for parallel summation
tags: #rust #tutorial #threads
cover_image: https://thepracticaldev.s3.amazonaws.com/i/yhwlnvi9zraevuf1xk08.jpg
---

One of the benefits of Rust is, in addition to safety, the ability to use threads without taking the risk of data races. Such flaws in your code should be detected by the compiler. The definition of a data race is pretty well stated:

> A data race occurs when two or more threads access the same memory location concurrently, and at least one of the accesses is for writing (ref. definition from Oracle docs)

My challenge was to imagine a simple use case scenario, where threads could add a definitive advantage (to some extent). Summing the elements of a vector is a perfect one because it can be broken down into individual tasks, independent from each others. In that case, all started threads could be responsible for summing up only a part of the vector's elements. 

As I'd like to achieve this for any type *T*, this entails the addition for this type is both commutative (because threads could be started in a non-deterministic manner) and associative. It's the case for complex, real, and integers numbers, but not for strings for example if we identify summation with concatenation operation.

I also wanted to use this example as an educational experiment on using threads on Rust, but without any additional crate. My opinion (which is controversial among Rustaceans) is that for such simple tasks, this should be in the core language, not shifted into an additional library. Take the *regex* crate: using it involves downloading and compiling 8 others crates:

```command
   Compiling memchr v2.2.0
   Compiling regex v1.1.7
   Compiling lazy_static v1.3.0
   Compiling ucd-util v0.1.3
   Compiling utf8-ranges v1.0.3
   Compiling thread_local v0.3.6
   Compiling regex-syntax v0.6.7
   Compiling aho-corasick v0.7.3
```

It seems this stand is not prevalent among people using Rust, but I strongly believe this is the way to go. Hopefully, it seems in the future some crates will be integrated into the *std*.

The overall process for summation is the following:

* each started thread will be responsible for a partial summation, depending on the number of threads
* each thread will send its result to the main thread using channels
* the main thread will reconcile and calculate the summation of partial sums which is equal to total summation

## Simple thread experiment
The following is a simple but enriching experiment on threads. Just spawn n-threads to print out values moved in each thread:

```rust
// just print out the value copied in each thread
fn thread_test<T>(val: T, nb_threads: usize) -> Vec<thread::JoinHandle<()>>
where
    T: 'static + Send + Sync + Copy + Debug,
{
    let mut v = Vec::new();

    for _ in 0..nb_threads {
        v.push(thread::spawn(move || {
            println!(
                "Value passed in thread {:?} = {:?}",
                thread::current().id(),
                val
            )
        }));
    }
    v
}
```

Two things here are key:

* the *'static* lifetime which gives an indication on how long the references pointed by an object of this type last
* the *Copy* thread is mandatory to pass *val* to each thread in a row. 

But not all types are copyable: *String* is not.

The previous *fn* could be used like this:

```rust
for th in thread_test(3.14f32, 2) {
    th.join();
}
```

## Version without any additional crate

I have to confess it was painful to achieve, specially compared with other languages like D or even over bloated C++. The main benefit was to learn how to use threads, communicate among thread using channels and the static lifetime.

Following is the code:

```rust
use std::fmt::Debug;
use std::ops::AddAssign;
use std::sync::mpsc;
use std::sync::Arc;
use std::thread;

// parall summation of a Vector of T elements
fn parallel_sum<T>(v: Vec<T>, nb_threads: usize) -> T
where
    T: 'static + Send + Sync + Debug + AddAssign + Default + Copy,
{
    // this vector will hold created threads
    let mut threads = Vec::new();

    // need to arced the vector to share it
    let arced = Arc::new(v);

    // this channel will be use to send values (partial sums) for threads
    let (sender, receiver) = mpsc::channel::<T>();

    // create requested number of threads
    for thread_number in 0..nb_threads {
        // increment ref count, will be moved into the thread
        let arced_cloned = arced.clone();

        // each thread gets its invidual sender
        let thread_sender = sender.clone();

        // create thread and save ID for future join
        let child = thread::spawn(move || {
            // initialize partial sum
            let mut partial_sum: T = T::default();

            // this line doesn't compile:
            // partial_sum = arced_cloned.into_iter().sum();

            // trivial old style loop: using the sum() method didn't help
            for i in 0..arced_cloned.len() {
                // depending on index, add it
                if i % nb_threads == thread_number {
                    partial_sum += *arced_cloned.get(i).unwrap();
                }
            }

            // send our result to main thread
            thread_sender.send(partial_sum).unwrap();

            // print out partial sum
            println!(
                "thread #{}, partial_sum of modulo {:?} = {:?}",
                thread_number, thread_number, partial_sum
            );
        });

        // save thread ID
        threads.push(child);
    }

    // wait for children threads to finish
    for child in threads {
        let _ = child.join();
    }

    let mut total_sum = T::default();
    for _ in 0..nb_threads {
        // main thread receives the partial sum from threads
        let partial_sum = receiver.recv().unwrap();

        // and get the final total sum
        total_sum += partial_sum
    }

    total_sum
}
```

This version is probably sub-optimal. Each thread could be allocated a partial range for applying the summation only on this range, saving the modulo operation on each index.

In the following articles, I'll use specific crates to achieve (hopefully) the same result.

Hope this helps !

> Photo by Héctor J. Rivas on Unsplash