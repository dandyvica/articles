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

pub trait Chunkable {
    // splits a Range into a vector of ranges at least of length chunk_size
    fn chunks(&self, chunk_size: usize) -> Vec<Range<usize>>;

    // divide a range into a vector of a maximum of n sub-ranges
    fn split_into(&self, n: usize) -> Vec<Range<usize>>;
}

impl Chunkable for Range<usize> {
    fn chunks(&self, chunk_size: usize) -> Vec<Range<usize>> {
        // create a vector from range containing all ranges
        // as the collect will contain refs, need to clone
        let tmp: Vec<_> = self.clone().collect();

        // empty vector will contain our ranges
        let mut v = Vec::new();

        // as we have now a vector, we can use the chunks() slice method
        // chunks will contain a vector a vectors
        let chunks = tmp.chunks(chunk_size);

        // convert each individual chunk into a range
        for chunk in chunks {
            println!("{:?}", chunk);
            v.push(chunk[0]..*chunk.last().unwrap() + 1);
        }

        v
    }

    fn split_into(&self, n: usize) -> Vec<Range<usize>> {
        self.chunks(self.len() / n)
    }
}

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
        // create a range with the number of elements of the vector
        let range = 0..self.len();

        // create a partition from that range
        let chunks = range.chunks(nb_threads);

        // create the channel to be able to receive partial sums from threads
        let (sender, receiver): (Sender<T>, Receiver<T>) = mpsc::channel();

        // this vec will hold thread handles spawend from this main thread
        let mut threads = Vec::new();

        // need to create an Arced version of the vector
        //let arced = Arc::new(self);

        // create threads: each thread will get the partial sum
        for chunk in chunks {
            // increment ref counter
            let arced_cloned = self.clone();

            // each thread gets its invidual sender
            let thread_sender = sender.clone();

            // spawn thread
            let child = thread::spawn(move || {
                // calculate partial sum
                let partial_sum: T = arced_cloned[chunk].iter().sum();

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

/*
pub trait MySum<T> {
    fn my_sum(&self, nb_threads: usize) -> T;
}

impl<T> MySum<T> for Vec<T>
where
    T: for<'a> std::iter::Sum<&'a T>
{
    fn my_sum(&self, nb_threads: usize) -> T
    {
        // create a range with the number of elements of the vector
        let range = 0..self.len();

        self.iter().sum::<T>()
    }
}
*/

pub const NB_THREADS: usize = 2;

fn multi1(v: &Arc<Vec<u64>>, nb_threads: usize) {
    for _ in 0..nb_threads {
        // increment internal Arc reference counter
        let arced_clone = v.clone();

        // spawn thread
        thread::spawn(move || {
            let partial_sum: u64 = arced_clone.iter().take(5).sum();
            println!(
                "partial_sum is {}, thread ID = {:?}",
                partial_sum,
                thread::current().id()
            );
        });
    }

    println!("Main thread thread ID = {:?}", thread::current().id());
    thread::sleep(Duration::from_millis(4000));
}

// splits a range into a vector of ranges
fn chunks(r: &Range<usize>, chunk_size: usize) -> Option<Vec<Range<usize>>> {
    // no reason to set a chunk size of zero
    if chunk_size == 0 {
        return None;
    }

    // create an empty vector to be filled in later
    let mut v = Vec::new();

    // calculate chunk parameters
    let div = (r.end - r.start) / chunk_size;
    let rem = (r.end - r.start) % chunk_size;
    println!("div={}, rem={}", div, rem);

    // then loop through chunks
    for i in 0..=div - 1 {
        let (start, end) = (i * chunk_size, (i + 1) * chunk_size);

        v.push(start..end);
    }

    // handle cases where range length is not a multiple of chunk_size
    if rem != 0 {
        let last_end = div * chunk_size;
        v.push(last_end..r.end);
    }

    Some(v)
}

fn main() {
    // sample size
    let n_max: usize = 20;
    let range = 0..n_max;

    // chunk size
    let chunk_size = 4;

    // create sample vector
    let mut v: Vec<u64> = (0..n_max).map(|e| e as u64 * 100).collect();
    println!("{:?}", v);

    println!("{:?}", (0..20).split_into(7));
    /*

    let w: Vec<_> = (0..20).collect();
    let ch: Vec<_> = w.chunks(2).collect();
    println!("{:?}", ch);

    // full range
    let full_range = 0..n_max;

    for i in 1..n_max {
        let ch: Vec<_> = w.chunks(i as usize).collect();
        println!("{} => {:?}", i, ch);
        println!("My {} => {:?}\n", i, chunks(&full_range, i as usize));
    }

    */

    /*
    let arced = Arc::new(v);
    let (sender, receiver): (Sender<u64>, Receiver<u64>) = mpsc::channel();
    let mut threads = Vec::new();

    for chunk in chunks(&range, 10).unwrap() {
        let arced_cloned = arced.clone();
        let thread_sender = sender.clone();

        // spawn thread
        let child = thread::spawn(move || {
            let partial_sum: u64 = arced_cloned[chunk].iter().sum();
            thread_sender.send(partial_sum).unwrap();

            println!(
                "partial_sum is {}, thread ID = {:?}",
                partial_sum,
                thread::current().id()
            );
        });

        threads.push(child);
    }

    // get results from threads
    let mut final_sum = 0u64;

    for i in 0..threads.len() {
        let partial_sum = receiver.recv().unwrap();
        println!("Received partial sum = {:?}", partial_sum);
        final_sum += partial_sum
    }

    //multi1(&Arc::new(v), NB_THREADS);
    println!("Main thread thread ID = {:?}", thread::current().id());
    thread::sleep(Duration::from_millis(4000));

    */
}
