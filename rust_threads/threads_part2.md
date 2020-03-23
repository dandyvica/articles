---
title: Using threads on Rust (part 2)
published: true
description: How to use threads on Rust for parallel task
tags: #rust #tutorial #threads
cover_image: https://thepracticaldev.s3.amazonaws.com/i/4hta8ch5lljj0r7gghap.jpg
---

Continuing my previous article on using Rust threads, it's time now to move on and use a more rusty approach by using dedicated crates.
With a little help of my friends (ref. to The Beatles intended !), I get useful advices from the Rust user group thread here: https://users.rust-lang.org/t/help-for-my-parallel-sum/29253.

It seems, for many reasons, that it's the way to go when using threads. I was a little bit reluctant at first to use external crates for such basic thread programming, but as it's becoming now the trend, I've given it a try. But rather than simply computing summation of vector elements, I just replaced the summation with a more generic function:

```rust
// function type which will run in each thread
type ChunkTask<'a, T> = fn(&'a [T]) -> T;
```

A function of this type will take a vector slice and return a *T* element. It could be anything: a summation, a summation of squares, a product, you name it. To apply this is a Rust idiomatic manner, I created a specific trait:

```rust
//---------------------------------------------------------------------------------------
// trait to call its fn directly from a Vec<T>
//---------------------------------------------------------------------------------------
pub trait ParallelTask<T> {
    // distribute work among threads. As a result, we'll got a Vec<T> which is the result of thread tasks
    fn parallel_task<'a>(&'a self, nb_threads: usize, computation: ChunkTask<'a, T>) -> Vec<T>
    where
        T: 'a + Send + Sync;
}
```

The *parallel_task* function will call the *computation* function on each task, on a slice which size depends on the number of threads. At the end, a vector of computed *T* elements is returned. Note that the order in which those elements are pushed in non-deterministic, due to the nature of OS threads.

The trick is to use the *crossbeam* crate which was created to alleviate some flaws in the *thread::scoped* API before Rust 1.0. The *scope* environment allows a more flexible way of using and creating threads:

```rust
impl<T> ParallelTask<T> for [T] {
    fn parallel_task<'a>(&'a self, nb_threads: usize, computation: ChunkTask<'a, T>) -> Vec<T>
    where
        T: 'a + Send + Sync,
    {
        // figure out the right size for the number of threads, rounded up
        let chunk_size = (self.len() + nb_threads - 1) / nb_threads;

        // create the channel to be able to receive partial sums from threads
        let (sender, receiver) = mpsc::channel::<T>();

        // create empty vector which will receive all computed valued from children threads
        let mut values: Vec<T> = Vec::new();

        crossbeam::scope(|scope| {
            // create threads: each thread will get the partial sum
            for chunk in self.chunks(chunk_size) {
                // each thread gets its invidual sender
                let thread_sender = sender.clone();

                // spawn thread
                scope.spawn(move |_| {
                    // call dedicated specialized fn
                    let partial_sum: T = computation(chunk);

                    // send it through channel
                    thread_sender.send(partial_sum).unwrap();
                });
            }

            // drop our remaining sender, so the receiver won't wait for it
            drop(sender);

            // sum the results from all threads
            values = receiver.iter().collect();
        })
        .unwrap();

        values
    }
}
```

Now, we can implement specialized functions. Those below are possible as soon as the *Sum* and *Prod* traits are implemented:

```rust
// a simple summation of elements
fn sum_fn<'a, T: Sum<&'a T>>(chunk: &'a [T]) -> T {
    chunk.into_iter().sum::<T>()
}

// summmation of squares of elements
fn sum_square_fn<'a, T>(chunk: &'a [T]) -> T
where
    T: Sum<&'a T> + Mul<Output = T> + Add<Output = T> + Default + Copy,
{
    chunk.into_iter().fold(T::default(), |sum, &x| sum + x * x)
}

// product of elements
fn prod_fn<'a, T: Product<&'a T>>(chunk: &'a [T]) -> T {
    chunk.into_iter().product::<T>()
}
```

Now it's easy to use the *parallel_task* method on a vector:

```rust
// first 20 integers
let vec: Vec<u64> = (1..=20).collect();

// parallel summation of integers
let mut v = vec.parallel_task(2, sum_fn);
println!("parallel_sum with 2 threads: {:?}", v);
assert_eq!(v.iter().sum::<u64>(), 210);

// parallel product of integer squares aka factorial
v = vec.parallel_task(4, prod_fn);
println!("parallel_product with 4 threads: {:?}", v);
assert_eq!(v.iter().product::<u64>(), 2432902008176640000);

// parallel sum of squares
v = vec.parallel_task(6, sum_square_fn);
println!("parallel_sum of squares with 6 threads: {:?}", v);
assert_eq!(v.iter().sum::<u64>(), 2870);  
```

But as the fn is a generic one, we can use any type. In the following, I use the *num* crate for complex numbers:

```rust
// parallel sum of complex squares
let complexes: Vec<Complex<u64>> = (1..=10).map(|i| Complex::new(i,i)).collect();
let mut v = complexes.parallel_task(6, sum_square_fn);
println!("parallel_sum of squares with 6 threads: {:?}", v);
assert_eq!(v.iter().sum::<Complex<u64>>(), Complex::new(0, 770));  
```

In the next article, I'll try to use the *rayon* crate which aims at simplifying parallel iteration, and use other types.

> Photo by Héctor J. Rivas on Unsplash