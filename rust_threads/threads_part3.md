---
title: Using threads on Rust (part 3)
published: true
description: How to use threads on Rust for a parallel task
tags: #rust #tutorial #threads
cover_image: https://thepracticaldev.s3.amazonaws.com/i/tbcvr93l7q1dc23i0dsg.jpg
---

If you followed my previous articles on using Rust native threads, you know how to parallelize a function applied to a vector of elements.
To illustrate this, a good example is the factorial computation: the product of the first *n* integers. This kind of computation is a perfect target to be run 
on several threads: the whole process can be chopped into different pieces, and the whole product is merely the product of partial products.

To be meaningful, the factorial of such a number should be large enough and beyond *u128* capabilities. As Rust doesn't get a built-in *BigInteger* class as in Java, I used the *num* crate which provides the *BigUint* struct. Beware this is probably not the most optimal one (compared to GMP for example).

Obviously, using a vector to calculate the factorial of an integer number is not the most efficient way. This is done only to illustrate my example.

Just import the *num* crate to use the *BigUint* type:

```rust
extern crate num;
use num::bigint::BigUint;
```

First, get the command line arguments:

```rust
// get arguments
let upper_bound = match args[1].parse::<u32>() {
    Ok(n) => n,
    Err(e) => panic!("error {} converting {} to an integer !", e, &args[1]),
};
let nb_threads = match args[2].parse::<u32>() {
    Ok(n) => n,
    Err(e) => panic!("error {} converting {} to an integer !", e, &args[2]),
};
```

To get the factorial, we first need to populate a vector of the first *n* *BigUint*:

```rust
// fill-in vector
let v: Vec<BigUint> = (1..=upper_bound).map(|i| BigUint::from(i)).collect();
```

Now, the mono-threaded computation is very easy, using the *Product* trait:

```rust
// get time for the mono-threaded product
let mut start = Instant::now();
let mono_fact = v.iter().product::<BigUint>();
let duration_mono = start.elapsed();
```

Computing the partial sums and the final product is the same:

```rust
// get time for multi-threaded computation
for num_thread in 2..=nb_threads {
    start = Instant::now();
    let partial_fact = v.parallel_task(num_thread as usize, prod_fn);
    let multi_fact = partial_fact.iter().product::<BigUint>();
    let duration_multi = start.elapsed();

    // validity check: check if products are equal
    assert_eq!(mono_fact, multi_fact);

    println!(
        "n={}, #threads={}, mono_threaded={:?}, {}_threaded={:?}, ratio={:.6}",
        upper_bound,
        num_thread,
        duration_mono,
        num_thread,
        duration_multi,
        duration_multi.as_nanos() as f64 / duration_mono.as_nanos() as f64
    );
}
```

The *assert_eq!* line is just here to make sure computations are equal. This is a sane safeguard against errors !

The *prod_fn* function is the same as in my previous articles:

```rust
// product of elements
fn prod_fn<'a, T: Product<&'a T>>(chunk: &'a [T]) -> T {
    chunk.into_iter().product::<T>()
}
```

Now it's possible to compare elapsed time for mono-threaded and multi-threaded computations. To be meaningful, I just created a 16-cores Amazon AWS instance, compiled the whole code in release mode, and ran it on my instance. I ran the process for n=20k, 50k, 75k, 100k, 150k and 200k.

Following are the results:

![](https://thepracticaldev.s3.amazonaws.com/i/e8ni62hsjfpuas3glspj.png)

The optimal time is found between 6 and 8 cores. Several factors can explain this outcome:

* the AWS instance processor is an *Intel(R) Xeon(R) Platinum 8124M CPU @ 3.00GHz* processor with 16 cores, but with the hyperthreading feature, not real cores. It seems the CPU has 16 cores but physically it's only 8 physical cores, and probably the optimal figure for computation
* CPU cache mechanism
* the more threads, the more the final *product of products* is taking time

Hope you appreciate ! 

> Photo by Gregory Culmer on Unsplash
