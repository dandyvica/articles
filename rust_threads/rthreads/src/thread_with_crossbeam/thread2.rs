use std::iter::Sum;
use std::sync::mpsc;

pub trait ParallelSum<T> {
    fn parallel_sum(&self, nb_threads: usize) -> T
    where
        T: for<'a> Sum<&'a T> + Sum<T> + Send + Sync;
}

impl<T> ParallelSum<T> for [T] {
    fn parallel_sum(&self, nb_threads: usize) -> T
    where
        T: for<'a> Sum<&'a T> + Sum<T> + Send + Sync,
    {
        // figure out the right size for the number of threads, rounded up
        let chunk_size = (self.len() + nb_threads - 1) / nb_threads;

        // create the channel to be able to receive partial sums from threads
        let (sender, receiver) = mpsc::channel::<T>();

        crossbeam::scope(|scope| {
            // create threads: each thread will get the partial sum
            for chunk in self.chunks(chunk_size) {
                // each thread gets its invidual sender
                let thread_sender = sender.clone();

                // spawn thread
                scope.spawn(move |_| {
                    // calculate partial sum
                    let partial_sum: T = chunk.iter().sum();

                    // send it through channel
                    thread_sender.send(partial_sum).unwrap();
                });
            }

            // drop our remaining sender, so the receiver won't wait for it
            drop(sender);

            // sum the results from all threads
            receiver.iter().sum()
        })
        .unwrap()
    }
}

fn main() {
    let vec: Vec<i32> = (0..1000).collect();
    println!("sum: {}", vec.iter().sum::<i32>());
    println!("parallel_sum(2): {}", vec.parallel_sum(2));
    println!("parallel_sum(4): {}", vec.parallel_sum(4));
}
