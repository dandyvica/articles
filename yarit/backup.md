We can modify the previous structure to become a finite one:

```rust
// just keep random number
struct RandomFiniteSequence {
    rng: rand::prelude::ThreadRng,
    limit: u16,
    counter: u16,
}

impl RandomFiniteSequence {
    fn new(limit: u16) -> RandomFiniteSequence {
        RandomFiniteSequence { 
            rng: rand::thread_rng(),
            limit: limit,
            counter: 0
        }
    }
}

// only implements Iterator
impl Iterator for RandomFiniteSequence {
    type Item = u8;

    // never exceed the limit
    fn next(&mut self) -> Option<Self::Item> {
        // each time called, imcrement our counter and end iteration if over
        self.counter += 1;

        if self.counter > self.limit {
            None
        }
        else {
            Some(self.rng.gen_range(1, 100))           
        }
    }
}

// Now, easy number for a lottery: get 10 numbers as a vector
// No control on duplicates
lottery = RandomFiniteSequence::new(10).collect();
assert_eq!(lottery.len(), 10);
println!("{:?}", lottery);
```

With a finite iterator, you can use many iterator methods, which come for free whenever *next()* is implemented:

```rust
let pseudo_iter = RandomFiniteSequence::new(10);
assert_eq!(pseudo_iter.count(), 10);
```
