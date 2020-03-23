// Keep track of n-1 and n values
struct Fibonacci {
    n_1: u64,
    n: u64,
}

// Fibonacci sequence is well known
impl Fibonacci {
    fn new() -> Fibonacci {
        Fibonacci {
            n_1: 0,
            n: 1,
        }
    }
}

// only implements Iterator and not IntoIterator
impl Iterator for Fibonacci {
    type Item = u64;

    fn next(&mut self) -> Option<Self::Item> {
        // Fibonacci sequence is well known
        let new_value = self.n + self.n_1;

        self.n_1 = self.n;
        self.n = new_value;

        Some(new_value)
    }
}