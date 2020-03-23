use std::clone::Clone;
use std::iter::{Product, Sum};
use std::ops::{Add, Mul};
use std::sync::mpsc;
use std::time::{Duration, Instant};

extern crate num;
use num::bigint::BigUint;
use num::complex::Complex;

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

fn exec_fn<'a, T>(chunk: &'a [T], func: ChunkTask<'a, T>) -> T {
    func(chunk)
}

//---------------------------------------------------------------------------------------
// Build a Van der Monde matrix
//---------------------------------------------------------------------------------------
// fn van_der_monde(n: usize, start: usize) -> DMatrix<f64>
// {
//     let vdm = DMatrix::from_fn(n, n, |i, j| {
//         // if j == 0 {
//         //     1f64
//         // } else {
//         //     ((start + i).pow(j as u32)) as f64
//         // }
//         if i == j { 1f64 } else { 0f64 }
//     });

//     vdm
// }

//---------------------------------------------------------------------------------------
// Uses different test scenarii
//---------------------------------------------------------------------------------------
fn main() {
    // first 20 integers
    let vec: Vec<u64> = (1..=20).collect();

    // parallel summation of integers
    let mut v = vec.parallel_task(2, sum_fn);
    println!("parallel_sum with 2 threads: {:?}", v);
    assert_eq!(v.iter().sum::<u64>(), 210);

    // parallel product of integer squares
    v = vec.parallel_task(4, prod_fn);
    println!("parallel_product with 4 threads: {:?}", v);
    assert_eq!(v.iter().product::<u64>(), 2432902008176640000);

    // parallel sum of squares
    v = vec.parallel_task(6, sum_square_fn);
    println!("parallel_sum of squares with 6 threads: {:?}", v);
    assert_eq!(v.iter().sum::<u64>(), 2870);

    // parallel sum of complex squares
    let complexes: Vec<Complex<u64>> = (1..=10).map(|i| Complex::new(i, i)).collect();
    let mut v = complexes.parallel_task(6, sum_square_fn);
    println!("parallel_sum of squares with 6 threads: {:?}", v);
    assert_eq!(v.iter().sum::<Complex<u64>>(), Complex::new(0, 770));

    // // parallel product of matrices
    // let mat = Matrix3::new(2f64, -2f64, -4f64, -1f64, 3f64, 4f64, 1f64, -2f64, -3f64);
    // println!("determinant = {}", mat.determinant());

    // // initialize a vector of large matrices
    // let mut mat_vec: Vec<MatrixN<10>> = Vec::new();
    // for i in 1..=1000 {
    //     mat_vec.push(van_der_monde(100, i));
    // }

    // // get time for the mono-threaded product
    // let mut start = Instant::now();
    // let product = mat_vec.iter().product::<Matrix3<f64>>();
    // let mut duration = start.elapsed();
    // println!(
    //     "time for the mono-threaded product of matrices: {:?}",
    //     duration
    // );

    // // get time for multi-threaded computation
    // start = Instant::now();
    // let m = mat_vec.parallel_task(8, prod_fn);
    // duration = start.elapsed();
    // println!(
    //     "time for the multi-threaded product of matrices: = {:?}",
    //     duration
    // );

    let bn1 = BigUint::new(vec![2]);
    let bn2 = BigUint::new(vec![2]);

    // fill-in vector
    let v: Vec<BigUint> = (1..=20000).map(|i| BigUint::new(vec![i])).collect();

    // get time for the mono-threaded product
    let mut start = Instant::now();
    let mono_fact = v.iter().product::<BigUint>().to_str_radix(10);
    let mut duration = start.elapsed();
    println!(
        "time for the mono-threaded product of integers: {:?}",
        duration
    );
    //println!("{:?}", mono_fact);

    // get time for multi-threaded computation
    start = Instant::now();
    let partial_fact = v.parallel_task(8, prod_fn);
    let multi_fact = partial_fact.iter().product::<BigUint>().to_str_radix(10);
    duration = start.elapsed();
    println!(
        "time for the multi-threaded product of matrices: = {:?}",
        duration
    );

    assert_eq!(mono_fact, multi_fact);
}
