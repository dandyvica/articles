fn main() {
// Vec<T> is a built-in type. No need to import
// uninitialized vector of unsigned 64-bit integers
let v1: Vec<u64>;

// initialized empty vector of unsigned 64-bit integers
let v2: Vec<u64> = Vec::new();

// initialized vector of unsigned 64-bit integers. Uses the vec! built-in macro. Note the mut modifier because I'll that vector later on. Otherwise, variable is immutable.
let mut digits = vec![0u64,1,2,3,4,5,6,7,8,9];

// initialized vector of 10 unsigned 64-bit integers equal to 1
let all_1 = vec![1u64;10];
let binomial_coefficients = vec![
vec![1u16],
vec![1u16,1],
vec![1u16,2,1],
vec![1u16,3,3,1],
vec![1u16,4,6,4,1],
vec![1u16,5,10,10,5,1]
];
// use of the assert_eq! macro which fails in case of error
assert_eq!(digits.len(), 10);
assert_eq!(binomial_coefficients.len(), 6);
// in that case, you need to provide the type of vector elements
let mut trigo: Vec<fn(f64) -> f64> = vec![f64::sin, f64::cos, f64::tan];

// or store closures (a.k.a. lambdas)
let powers: Vec<fn(u64) -> u64> = vec![
|x: u64| x.pow(2),
|x: u64| x.pow(3),
|x: u64| x.pow(4),
];
// get first element reference
let first_binomial = &binomial_coefficients[0];

// need to clone if you really want a copy
let first_binomial_cloned = binomial_coefficients[0].clone();

// no negative indexes but you can implement the Index/IndexMut traits for your structs
use std::ops::Index;

struct BinomialCoefficient {
coeff: Vec<Vec<u16>>,
}

impl Index<isize> for BinomialCoefficient {
type Output = Vec<u16>;

fn index(&self, i: isize) -> &Vec<u16> {
if i >= 0 {
&self.coeff[i as usize]
}
else {
&self.coeff[self.coeff.len()-i.abs() as usize]
}

}
}

// Use clone to re-use the binomial_coefficients variable afterwards, otherwise it's moved and gone.
let my_binomials = BinomialCoefficient { coeff: binomial_coefficients.clone() };
assert_eq!(my_binomials[-1], vec![1u16,5,10,10,5,1]);

let first3_binomials = &binomial_coefficients[0..3];
assert_eq!(first3_binomials.len(), 3);
let first4_binomials = &binomial_coefficients[0..=3];
assert_eq!(first4_binomials.len(), 4);
digits.push(10);
assert_eq!(digits, vec![0,1,2,3,4,5,6,7,8,9,10]);
digits.remove(10);
assert_eq!(digits, vec![0,1,2,3,4,5,6,7,8,9]);

digits = vec![0,1,2,3,4];
digits.append(&mut vec![5,6]);
digits.append(&mut vec![7,8,9]);
assert_eq!(digits, vec![0,1,2,3,4,5,6,7,8,9]);
// need to use the reference on element (&)
if digits.contains(&9) {
println!("9 is a digit ! Such a surprise ;-)");
}
// use reference: digits is borrowed (in the ownership sense of Rust) and
// so is usable afterwards
for d in &digits {
println!("{}", d);
}

// use mutable reference: allows to modify elements
for d in &mut digits {
*d += 1u64;
println!("{}", d);
}

// beware: digits elements are modified due to the previous loop
assert_eq!(digits, vec![1,2,3,4,5,6,7,8,9,10]);

//  digits ownership is moved due to the underlying construct implementation. digits is gone
for d in digits {
println!("{}", d);
}
// reset digits
digits = vec![0u64,1,2,3,4,5,6,7,8,9];

// need to add the iter() because digits is not an iterator
// (i.e. doesn't implement the Iterator trait )
digits.iter().for_each( |d| println!("{}", d) );
// enumerate() yields a tuple
digits.iter().enumerate().for_each( |(i,d)|
println!("{} is the {}-th digit", d, i)
);
// note the type specification (<u64>) for hint the compiler about type
assert_eq!(digits.iter().sum::<u64>(), 45);

// min & max return an Option<>, need to unwrap()
assert_eq!(digits.iter().max().unwrap(), &9);
assert_eq!(digits.iter().min().unwrap(), &0);
assert_eq!(Vec::<u64>::new().iter().min(), None);

// build lipsum vector using split() and collect()
// beware: str references are returned
let lipsum: Vec<&str> = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split(" ").collect();
assert_eq!(lipsum.iter().max_by_key(|w| w.len()).unwrap(), &"consectetur");
let a = vec![0,1,2,3];
let b = vec![4,5,6,7];

// collect() is used to create a vector from the iterator
let zipped: Vec<_> = a.iter().zip(b.iter()).collect();
assert_eq!(zipped, vec![(&0,&4), (&1,&5), (&2,&6), (&3,&7)]);
// extract words ending with 't'
let end_with_t: Vec<_> = lipsum.iter().filter( |w| w.ends_with("t") ).collect();
assert_eq!(end_with_t, vec![&"sit", &"incididunt", &"ut", &"et"]);

// convert to uppercase
let upper: Vec<_> = lipsum.iter().map( |w| w.to_uppercase() ).collect();
assert_eq!(upper[0], "LOREM");

// get only words of length 5 (including commas)
let words5: Vec<_> = lipsum.iter().filter( |w| w.len() == 5 ).collect();
assert_eq!(words5, vec![&"Lorem", &"ipsum", &"dolor", &"amet,", &"elit,", &"magna"]);

// trigo is already declared earlier...
trigo = vec![f64::sin, f64::cos, f64::tan];

let values: Vec<_> = trigo.iter().map( |f| f(std::f64::consts::PI/4f64)).collect();
// cannot check exact equality for floats. Uses this trick
assert!(f64::abs(values[0] - f64::sqrt(2f64)/2f64) < 10E-6f64);
// this creates a vector of a-z chars
let mut a_to_z: Vec<_> = "abcdefghijklmnopqrstuvwxyz".chars().collect();
assert_eq!(a_to_z.len(), 26);

// create digits and the first 100 even numbers. Note the closed range 0..=9 notation. No need to use *iter()* because a range is implements the Iterator trait
digits = (0..=9).collect();
digits = vec![0,1,2,3,4,5,6,7,8,9];

let even: Vec<_> = (0..100).step_by(2).collect();
assert_eq!(even.last().unwrap(), &98);
// Keep track of n-1 and n values
struct Fibonacci {
fib_n_1: u64,
fib_n: u64,
}

// Fibonacci sequence is well known
impl Fibonacci {
fn new() -> Fibonacci {
Fibonacci {
// use of max_value() to handle fib_0 and fib_1
fib_n_1: u64::max_value(),
fib_n: u64::max_value(),
}
}
}

// only implements Iterator and not IntoIterator
impl Iterator for Fibonacci {
type Item = u64;

fn next(&mut self) -> Option<Self::Item> {
let next_fib: u64;

// also handle fib_0
if self.fib_n_1 == u64::max_value() {
next_fib = 0;

self.fib_n_1 = 1;
}
// handle fib_1
else if self.fib_n == u64::max_value() {
next_fib = 1;

self.fib_n_1 = 0;
self.fib_n = 1;
}
else {
// Fibonacci sequence is well known
next_fib = self.fib_n + self.fib_n_1;

self.fib_n_1 = self.fib_n;
self.fib_n = next_fib;
}

Some(next_fib)
}
}

let fibo = Fibonacci::new();

// use take() adapter because the iterator is infinite
let first_values: Vec<_> = fibo.take(11).collect();
assert_eq!(first_values, vec![0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]);
a_to_z = "abcdefghijklmnopqrstuvwxyz".chars().collect();
let A_to_Z: Vec<_> = a_to_z.iter().map( |c| c.to_uppercase() ).collect();

// map() uses a block which can be more advanced
let greek = vec!['α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ', 'ν', 'ξ', 'ο', 'π', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω'];
let translated: Vec<_> = greek.iter().map( |g|
match g {
'α' => 'A',
'β' => 'B',
'γ' => 'C',
// and so on
_ => 'X',
}
).collect();
assert_eq!(&translated[0..4], &['A', 'B', 'C', 'X']);
digits = (0..=9).collect();
let tenths: Vec<_> = digits.iter().map( |x| x*10 ).collect();
assert_eq!(tenths, vec![0, 10, 20, 30, 40, 50, 60, 70, 80, 90]);
// contrived example
fn square(x: u64) -> u64 {
x*x
}

// calculate the first 9 perfect squares
let squares: Vec<_> = digits.iter().map( |x| square(*x) ).collect();
assert_eq!(squares, vec![0, 1, 4, 9, 16, 25, 36, 49, 64, 81]);
// extract even numbers
let even: Vec<_> = digits.iter().filter( |n| *n%2 == 0 ).collect();
assert_eq!(even, vec![&0, &2, &4, &6, &8]);

// extract words less than 4 chars
let words4: Vec<_> = lipsum.iter().filter( |w| w.len() < 4 ).collect();
assert_eq!(words4, vec![&"sit", &"sed", &"do", &"ut", &"et"]);
// sum of first 10 digits
assert_eq!(digits.iter().fold(0, |x, y| x + y), 45);

fn nested(coeff: &[u64], z: u64) -> u64 {
coeff.iter().fold(0, |x, y| z*x + y)
}
assert_eq!(nested(&[1,5,10,10,5,1], 1), 32);

// easy computation of the nested square root which converges to the golden ratio
let golden = (1.0+f64::sqrt(5.0))/2.0;

let mut approx_golden = vec![1f64;100].iter().fold(1f64, |x,y| f64::sqrt(x+y));
assert!(f64::abs(approx_golden - golden) < 10E-6f64);

approx_golden = vec![1f64;100].iter().fold(1f64, |x,y| y+1f64/x);
assert!(f64::abs(approx_golden - golden) < 10E-6f64);
}
