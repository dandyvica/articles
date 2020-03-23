---
title: YARIT: Yet Another Rust Iterators Tutorial
published: false
description: Rust iterators
tags: #rust #tutorial #beginners #functional
cover_image: https://thepracticaldev.s3.amazonaws.com/i/5x7mft6jwfym156rcrlz.jpg
---

OK, that's not the most mind-blowing title, but in this article, I'll tackle Rust iterators. They are key for writing idiomatic Rust code. 

To fully understand the following article, you should have a minimum knowledge of traits, because they are part of the Iterator apparatus, and be aware of the Rust's ownership system.

Iterators are quite simple but sometimes difficult to grab. Specially when it comes to understand the difference between *iter()* and *iter_mut()* ad-hoc methods and *into_iter()* trait method.

## Iterators: TL;DR

For those who are in a hurry and just want the essence of Rust iterators.

### Iterators

* a Rust iterator is a value (structure, enum, ...) which implements the *Iterator* trait, which boils down to write the *next()* method. Once done, the value becomes iterable
* this *Iterator::next()* method is called either explicitly or under the hood by the *for-in* construct or by other *Iterator* trait methods called *adapters*
* *Iterator::next()* returns an *Option&lt;T>* type:
  * if *None* is returned, iteration stops. If *None* is never returned, the iterator is infinite
  * if *Some(T)* is returned, iteration continues
* once *Iterator::next()* is implemented, other trait' methods come for free (e.g.: *take()*)


### Adapters

* a Rust iterator adapter (or just an adapter) is a method from the *Iterator* trait which takes an iterator and returns either another iterator (e.g.: *take()*), or a single value (e.g: *count()*, *nth()*, ...)
* among those methods, *collect()* is of paramount importance because it converts an iterator into a collection

> it's important to note that iterator adapters take their input by value using *self* as their first parameters, not by reference or mutable reference. This means their input value is moved once used

### *IntoIterator* trait

* this trait defines one method used to transfrom a value into an iterator: *into_iter()*
* this method consumes *self* by value:
  
```rust
fn into_iter(self) -> Self::IntoIter; 
```

which means that when used with a value (not a reference), that value is moved and gone forever.

* this method is used implicitly during the *for-in* construct:

```rust
// loop through a vector
let v = vec![0,1,2,3];

// standard loop
for i in v {
    // blah blah
}

// this desugars as
let mut iter = IntoIterator::into_iter(v);
loop {
    match iter.next() {
        Some(i) => { 
            // blah blah 
        },
        None => break,
    }
}
```
* but can also be used explicitly with adapters:

```rust
let v1 = vec![0,1,2,3];

// after that, v1 is moved and not longer accessible
assert_eq!(v1.into_iter().count(), 4);

let mut v2 = vec![0,1,2,3];

// that way, it's possible to re-use v2, but clumsy and not very elegant
assert_eq!((&v2).into_iter().count(), 4);
assert_eq!((&v2).into_iter().nth(1).unwrap(), &1);
assert_eq!((&mut v2).into_iter().nth(1).unwrap(), &mut 1);
```

> Once *Iterator* is implemented, *IntoIterator* is automatically implemented.

### Rust standard collections  

* all Rust standard collections implement *into_iter()*, but return different types depending on whether it's applied on a reference or a value:

Variable type | Type returned by *into_iter()* | Type returned by *next()*
------------ | -------------|----------
*Vec&lt;T>* | std::iter::IntoIterator&lt;T> | T
*&Vec&lt;T>* | std::slice::Iter&lt;T> | &T
*&mut Vec&lt;T>* | std::slice::IterMut&lt;T> | &mut T
 
* to get rid of the previous clumsy syntax, Rust collections usually propose ad-hoc methods *iter()* to iterate by reference and *iter_mut()* by mutable reference. This leads to the following cleaner syntax:

```rust
// much more elegant and easy to read syntax
assert_eq!(v2.iter().count(), 4);
assert_eq!(v2.iter().nth(1).unwrap(), &1);
assert_eq!(v2.iter_mut().nth(1).unwrap(), &mut 1);
```
  

### *FromIterator* trait

The *FromIterator* trait is used to convert an iterator into a user-defined collection, and called by the *Iterator::collect()* method.

## Implementing your own iterators

Now you've read the overview, it's time to see practical examples on how implementing iterators on your own data structures.

Let's write a Fibonacci sequence which can be infinite or finite depending on how it's created:

```rust
// Simplified version of a Fibonacci sequence: F0 and F1 are not returned
// Keep track of n-1 and n values
#[derive(Clone)]
struct Fibonacci {
    fib_n_1: u64,
    fib_n: u64,
    limit: Option<u64>,     // maximum Fibonacci number, None if infinite
}

// Fibonacci sequence is well known
impl Fibonacci {
    fn new(limit: Option<u64>) -> Fibonacci {
        Fibonacci {
            fib_n_1: 0,
            fib_n: 1,
            limit: limit, 
        }
    }
}
```

Now, we can directly implement the *Iterator* trait:

```rust
// only implements Iterator and not IntoIterator
impl Iterator for Fibonacci {
    type Item = u64;

    fn next(&mut self) -> Option<Self::Item> {
        let next_fib = self.fib_n + self.fib_n_1;

        self.fib_n_1 = self.fib_n;
        self.fib_n = next_fib;

        // infinite sequence?
        if self.limit.is_none() {
            Some(next_fib)             
        }
        else {
            // don't overflow the limit
            if next_fib > self.limit.unwrap() {
                None
            }
            // ok we can loop
            else {
                Some(next_fib)  
            }
        }
    }   
}
```

and play and iterate on Fibonacci:

```rust
// this is an infinite sequence
let inf_fibo = Fibonacci::new(None);

// we can use adapter on our struct, but as take(), it consumes fibo which is moved and gone. That's why it's cloned
let first_values: Vec<_> = inf_fibo.take(11).collect();
assert_eq!(first_values, vec![1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144]);

// this is an finite sequence
let fin_fibo = Fibonacci::new(Some(100_000));

// our Fibonacci starts from n=2: 24 numbers < 100_000 (from F2 to F26)
assert_eq!(fin_fibo.clone().count(), 24);

// F25 = 75025
assert_eq!(fin_fibo.clone().nth(23).unwrap(), 75025);

// another way, enumerate() yields a tuple
let f25 = fin_fibo.clone().enumerate().nth(23).unwrap();
assert_eq!(f25.0, 23);
assert_eq!(f25.1, 75025);

// F25 is also the last one
assert_eq!(fin_fibo.clone().last().unwrap(), 75025);

// get even Fibonacci numbers
let even_fibo: Vec<_> = fin_fibo.clone().filter(|fib| fib%2 == 0).collect();
assert_eq!(even_fibo, vec![2, 8, 34, 144, 610, 2584, 10946, 46368]);
```

Now, the previous structure was quite simple and its iterator is consuming its data. How about a user-defined collection? 

Let's make a try.

## Iterators on user-defined collections

Let's imagine a user-defined collection which splits a phrase into individual words, store those words into a vector:

```rust
// a structure holding &str, just a wrapper on &str vector
struct Words<'a> {
    words: Vec<&'a str>,
}

// just split input text into invidual words
impl<'a> Words<'a> {
    fn new(init: &str) -> Words {
        Words {
            words: init.split(" ").collect(),
        }
    }
}
```

Implementing the *Iterator* trait makes no sense here because it's only usable once when combined with an adapter. The trick is to implement the *IntoIterator* trait, which transforms *Words* into an intermediate structure helper. This latter structure must then implements the *Iterator* trait to be iterable.

But keep in mind there're 3 implementations to write whether you need to consume collection elements or not: one for a consuming iterator, one for a non-consuming iterator and one for a mutable non-consuming iterator.

First, implement the consuming iterator:

```rust
// structure helper for consuming iterator.
struct IntoIteratorHelper<'a> {
    iter: ::std::vec::IntoIter<&'a str>,
}

// implement the IntoIterator trait for a consuming iterator. Iteration will
// consume the Words structure 
impl<'a> IntoIterator for Words<'a> {
    type Item = &'a str;
    type IntoIter = IntoIteratorHelper<'a>;

    // note that into_iter() is consuming self
    fn into_iter(self) -> Self::IntoIter {
        IntoIteratorHelper {
            iter: self.words.into_iter(),
        }
    }
}

// now, implements Iterator trait for the helper struct, to be used by adapters
impl<'a> Iterator for IntoIteratorHelper<'a> {
    type Item = &'a str;

    // just return the str reference
    fn next(&mut self) -> Option<Self::Item> {
            self.iter.next()
    }
}
```

And now, the non-consuming iterator:

```rust
// structure helper for non-consuming iterator.
struct IterHelper<'a> {
    iter: ::std::slice::Iter<'a, &'a str>,
}

// implement the IntoIterator trait for a non-consuming iterator. Iteration will
// borrow the Words structure 
impl<'a> IntoIterator for &'a Words<'a> {
    type Item = &'a &'a str;
    type IntoIter = IterHelper<'a>;

    // note that into_iter() is consuming self
    fn into_iter(self) -> Self::IntoIter {
        IterHelper {
            iter: self.words.iter(),
        }
    }
}

// now, implements Iterator trait for the helper struct, to be used by adapters
impl<'a> Iterator for IterHelper<'a> {
    type Item = &'a &'a str;

    // just return the str reference
    fn next(&mut self) -> Option<Self::Item> {
            self.iter.next()
    }
}
```

And finally the mutable non-consuming iterator:


```rust
// structure helper for mutable non-consuming iterator.
struct IterMutHelper<'a> {
    iter: ::std::slice::IterMut<'a, &'a str>,
}

// implement the IntoIterator trait for a mutable non-consuming iterator. Iteration will
// mutably borrow the Words structure 
impl<'a> IntoIterator for &'a mut Words<'a> {
    type Item = &'a mut &'a str;
    type IntoIter = IterMutHelper<'a>;

    // note that into_iter() is consuming self
    fn into_iter(self) -> Self::IntoIter {
        IterMutHelper {
            iter: self.words.iter_mut(),
        }
    }
}

// now, implements Iterator trait for the helper struct, to be used by adapters
impl<'a> Iterator for IterMutHelper<'a> {
    type Item = &'a mut &'a str;

    // just return the str reference
    fn next(&mut self) -> Option<Self::Item> {
            self.iter.next()
    }
}
```

We can also implement the *FromIterator* trait to be fairly comprehensive:

```rust
use std::iter::FromIterator;

// implement FromIterator
impl<'a> FromIterator<&'a str> for Words<'a> {
    fn from_iter<T>(iter: T) -> Self
    where
        T: IntoIterator<Item = &'a str> {

        // create and return Words structure
        Words {
            words: iter.into_iter().collect(),
        }
    }
}
```

To give the final capstone, we should implement *iter()* and *iter_mut()* methods for *Words*:

```rust
// just split input text into invidual words
impl<'a> Words<'a> {
    fn iter(&'a self) -> IterHelper<'a> {
        self.into_iter()
    }

    fn iter_mut(&'a mut self) -> IterMutHelper<'a> {
        self.into_iter()
    }    
}
```

That's a lot of boilerplate code but it can be reduce using ad-hoc macros. I'll tackle Rust macros in another article. Now we can use all the iterator framework on our collection:

```rust
let mut uw = Words::new("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.");

assert_eq!((&uw).into_iter().count(), 19);

// loop through &uw
for w in &uw {
    println!("{}", w);
}

// user iter()
let upper: Vec<_> = uw.iter().map(|w| w.to_uppercase()).collect();
assert_eq!(upper[0], "LOREM");

// we can modify elements now
for w in &mut uw {
    println!("{}", w);
}

// FromIterator tryout
let lipsum_short: Words = vec!["Lorem", "ipsum", "dolor", "sit", "amet"].iter().map(|w| *w).collect();
assert_eq!(lipsum_short.words, vec!["Lorem", "ipsum", "dolor", "sit", "amet"]);
```

Lots of code in this article, but everything compiles with the lastest Rust compiler v1.34.1. Feel free to comment and ask.

> Photo by bert sz on Unsplash



