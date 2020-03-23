use std::fmt::Debug;
use std::iter::Sum;
use std::marker::Send;
use std::ops::Add;
use std::ops::AddAssign;
use std::ops::Range;
use std::sync::mpsc;
use std::sync::mpsc::{Receiver, Sender};
use std::sync::Arc;
use std::thread;
use std::time::Duration;
use std::fmt::Display;

/*
pub trait ParallelSum<T> {
    fn parallel_sum<'a>(&self, nb_threads: usize) -> T
    where
        T: 'a + Sum<&'a T> + Send + Sync + Default + AddAssign;
}

impl<T> ParallelSum<T> for Arc<Vec<T>> {
    fn parallel_sum<'a>(&self, nb_threads: usize) -> T
    where
        T: 'a + Sum<&'a T> + Send + Sync + Default + AddAssign,
    {
        // create the channel to be able to receive partial sums from threads
        let (sender, receiver) = mpsc::channel::<T>();

        // this vec will hold thread handles spawend from this main thread
        let mut threads = Vec::new();

        // need to create an Arced version of the vector
        //let arced = Arc::new(self);

        // create threads: each thread will get the partial sum
        for i in 0..nb_threads {
            // increment ref counter
            let arced_cloned = self.clone();

            // each thread gets its invidual sender
            let thread_sender = sender.clone();

            // spawn thread
            let child = thread::spawn(move || {
                // calculate partial sum
                let partial_sum: T = arced_cloned.iter().sum();

                // send it through channel
                thread_sender.send(partial_sum).unwrap();
            });

            // save thread ID
            threads.push(child);
        }

        // get results from threads
        let mut total_sum = T::default();

        for _ in 0..threads.len() {
            // main thread receives the partial sum from threads
            let partial_sum = receiver.recv().unwrap();

            //println!("Received partial sum = {:?}", partial_sum);

            // and get the final total sum
            total_sum += partial_sum
        }

        total_sum
    }
}
*/

fn parallel_sum<T>(v: Vec<T>, nb_threads: usize)
where
    T: 'static+Sum<&'static T> + Send + Sync + Default + Debug + AddAssign,
{
    //println!("Sum {:?} = {:?}", v, v.iter().sum::<T>());

    // create the channel to be able to receive partial sums from threads
    let (sender, receiver) = mpsc::channel::<T>();

    // this vec will hold thread handles spawend from this main thread
    let mut threads = Vec::new();

    // need to create an Arced version of the vector
    let arced = Arc::new(v);

    // create threads: each thread will get the partial sum
    for i in 0..nb_threads {
        // increment ref counter
        let arced_cloned = arced.clone();

        // each thread gets its invidual sender
        let thread_sender = sender.clone();

        // spawn thread
        let child = thread::spawn(move || {
            // calculate partial sum
            /*
            let partial_sum: T = arced_cloned
                .iter()
                .enumerate()
                .filter(|(j, _)| j % nb_threads == i)
                .map(|(_, e)| e)
                .sum();
            
            */

            let mut partial_sum = T::default();
            
            for j in 0..arced_cloned.len() {
                partial_sum += arced_cloned[j];
            }

            println!("I'm in thread {}, partial sum = {:?} ", i, partial_sum);

            // send it through channel
            thread_sender.send(partial_sum).unwrap();
        });

        // save thread ID
        threads.push(child);
    }

    let mut total_sum = T::default();

    for _ in 0..threads.len() {
        // main thread receives the partial sum from threads
        let partial_sum = receiver.recv().unwrap();

        //println!("Received partial sum = {:?}", partial_sum);

        // and get the final total sum
        total_sum += partial_sum
    }
    println!("Total sum = {:?}", total_sum);

    // wait for threads to finish
    for child in threads {
        // Wait for the thread to finish. Returns a result.
        let _ = child.join();
    }
}

fn main() {
    // create sample vector
    let mut v: Vec<u64> = (0..10).map(|e| e as u64 * 100).collect();
    println!("Sum {:?} = {}", v, v.iter().sum::<u64>());

    parallel_sum(v, 4);

    /*
    // create the channel to be able to receive partial sums from threads
    let (sender, receiver) = mpsc::channel::<u64>();

    // this vec will hold thread handles spawend from this main thread
    let mut threads = Vec::new();

    let nb_threads = 4;

    // need to create an Arced version of the vector
    let arced = Arc::new(v);

    // create threads: each thread will get the partial sum
    for i in 0..nb_threads {
        // increment ref counter
        let arced_cloned = arced.clone();

        // each thread gets its invidual sender
        let thread_sender = sender.clone();

        // spawn thread
        let child = thread::spawn(move || {
            // calculate partial sum
            let partial_sum: u64 = arced_cloned
                .iter()
                .enumerate()
                .filter(|(j, _)| j % nb_threads == i)
                .map(|(_, e)| e)
                .sum();
            println!("I'm in thread {}, partial sum = {} ", i, partial_sum);

            // send it through channel
            thread_sender.send(partial_sum).unwrap();
        });

        // save thread ID
        threads.push(child);
    }

    /*
    // get results from threads
    let mut total_sum = T::default();

    for _ in 0..threads.len() {
        // main thread receives the partial sum from threads
        let partial_sum = receiver.recv().unwrap();

        //println!("Received partial sum = {:?}", partial_sum);

        // and get the final total sum
        total_sum += partial_sum
    }*/

    //let total_sum: u64 = receiver.iter().sum();
    //println!("Total sum = {}", total_sum);

    let mut total_sum = 0u64;

    for _ in 0..nb_threads {
        // main thread receives the partial sum from threads
        let partial_sum = receiver.recv().unwrap();

        //println!("Received partial sum = {:?}", partial_sum);

        // and get the final total sum
        total_sum += partial_sum
    }
    println!("Total sum = {}", total_sum);

    // wait for threads to finish
    for child in threads {
        // Wait for the thread to finish. Returns a result.
        let _ = child.join();
    }

    */
}
