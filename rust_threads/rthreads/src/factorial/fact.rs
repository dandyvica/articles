use std::clone::Clone;
use std::iter::{Product, Sum};
//use std::ops::{Add, Mul};
use std::env;
use std::sync::mpsc;
use std::time::Instant;

extern crate num;
use num::bigint::BigUint;

// function type which will run in each thread
type ChunkTask<'a, T> = fn(&'a [T]) -> T;

//---------------------------------------------------------------------------------------
// trait to call its fn directly from a Vec<T>
//---------------------------------------------------------------------------------------
pub trait ParallelTask<T> {
    // distribute work among threads. As a result, we'll got a Vec<T> which is the result of thread tasks
    fn parallel_task<'a>(&'a self, nb_threads: usize, computation: ChunkTask<'a, T>) -> Vec<T>
    where
        T: 'a + Send + Sync;
}

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

//---------------------------------------------------------------------------------------
// Samples of computation functions in each thread
//---------------------------------------------------------------------------------------

// // a simple summation of elements
// fn sum_fn<'a, T: Sum<&'a T>>(chunk: &'a [T]) -> T {
//     chunk.into_iter().sum::<T>()
// }

// // summmation of squares of elements
// fn sum_square_fn<'a, T>(chunk: &'a [T]) -> T
// where
//     T: Sum<&'a T> + Mul<Output = T> + Add<Output = T> + Default + Copy,
// {
//     chunk.into_iter().fold(T::default(), |sum, &x| sum + x * x)
// }

// product of elements
fn prod_fn<'a, T: Product<&'a T>>(chunk: &'a [T]) -> T {
    chunk.into_iter().product::<T>()
}

//---------------------------------------------------------------------------------------
// Uses different test scenarii
//---------------------------------------------------------------------------------------
fn main() {
    // manage arguments
    let args: Vec<String> = env::args().collect();
    if args.len() != 3 {
        println!("fact [upper_bound] [nb_thread]");
        return;
    }

    // get arguments
    let upper_bound = match args[1].parse::<u32>() {
        Ok(n) => n,
        Err(e) => panic!("error {} converting {} to an integer !", e, &args[1]),
    };
    let nb_threads = match args[2].parse::<u32>() {
        Ok(n) => n,
        Err(e) => panic!("error {} converting {} to an integer !", e, &args[2]),
    };

    // fill-in vector
    let v: Vec<BigUint> = (1..=upper_bound).map(|i| BigUint::from(i)).collect();

    // get time for the mono-threaded product
    let mut start = Instant::now();
    let mono_fact = v.iter().product::<BigUint>();
    let duration_mono = start.elapsed();

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
}
