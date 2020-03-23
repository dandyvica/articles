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

    // terminate sender and get final sum
    //drop(sender);

    let mut total_sum = T::default();
    for _ in 0..nb_threads {
        // main thread receives the partial sum from threads
        let partial_sum = receiver.recv().unwrap();

        // and get the final total sum
        total_sum += partial_sum
    }

    total_sum
}

// compare summation of vectors
macro_rules! compare_sums {
    ($v:ident, $nb_threads:expr, $type:ty) => {
        let sums = ($v.iter().sum::<$type>(), parallel_sum($v, $nb_threads));
        println!(
            "Mono-threads sum = {}, multi-threaded sum with {:?} threads = {}",
            sums.0, sums.1, $nb_threads
        );
    };
}

fn main() {
    // vector of u32
    let v1: Vec<u32> = (0..10000).collect();
    compare_sums!(v1, 2, u32);

    // vector of floats
    let v2: Vec<f64> = (0..10000).map(|e| 3.141592 * e as f64).collect();
    compare_sums!(v2, 4, f64);
}
