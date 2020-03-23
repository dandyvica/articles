fn main() {
let v1 = vec![0,1,2,3];

// after that, v1 is moved and not longer accessible
assert_eq!(v1.into_iter().count(), 4);

let mut v2 = vec![0,1,2,3];

// that way, it's possible to re-use v2, but clumsy and not very elegant
assert_eq!((&v2).into_iter().count(), 4);
assert_eq!((&v2).into_iter().nth(1).unwrap(), &1);
assert_eq!((&mut v2).into_iter().nth(1).unwrap(), &mut 1);
// much more elegant and easy to read syntax
assert_eq!(v2.iter().count(), 4);
assert_eq!(v2.iter().nth(1).unwrap(), &1);
assert_eq!(v2.iter_mut().nth(1).unwrap(), &mut 1);
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
// just split input text into invidual words
impl<'a> Words<'a> {
fn iter(&'a self) -> IterHelper<'a> {
self.into_iter()
}

fn iter_mut(&'a mut self) -> IterMutHelper<'a> {
self.into_iter()
}
}
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
}
