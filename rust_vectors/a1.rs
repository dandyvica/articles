use std::ops::Index;

// compose over Vector
// struct MyVec {
//     vec: Vec<u64>,
// }

// impl MyVec {
//     // nothing groundbreaking here
//     fn new() -> MyVec {
//         MyVec {
//             vec: Vec::new(),
//         }
//     }
// }

// // special implementation
// impl Index<Vec<usize>> for MyVec {
//     type Output = Vec<usize>;

//     fn index<'a>(&'a self, index_list: Vec<usize>) -> &'a Vec<usize> {
//         let extract: Vec<_> = self.vec.iter().enumerate().filter( |(i,e)| index_list.contains(i)).collect();

//         &extract
//     }
// }


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




fn main() {

// Vec<T> is a built-in type. No need to import
// uninitialized ?? vector of unsigned 64-bit integers
let v1: Vec<u64>;      

// initialized empty vector of unsigned 64-bit integers
let v2: Vec<u64> = Vec::new();  

// initialized ?? vector of unsigned 64-bit integers. Uses the vec! built-in macro
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

// in that case, you need to provide the type
let mut trigo: Vec<fn(f64) -> f64> = vec![f64::sin, f64::cos, f64::tan];

// or store closures (a.k.a. lambdas)
let powers: Vec<fn(u64) -> u64> = vec![
    |x: u64| x.pow(2),
    |x: u64| x.pow(3),
    |x: u64| x.pow(4),
];

digits.push(10);
assert_eq!(digits.len(), 11);

digits.remove(10);
assert_eq!(digits.len(), 10);

digits = vec![0,1,2,3,4];
digits.append(&mut vec![5,6]);
digits.append(&mut vec![7,8,9]);
assert_eq!(digits.len(), 10);

if digits.contains(&9) {
    println!("9 is a digit ! Such a surprise ;-)");
}

// use reference: digits is borrowed (in the ownership sense of Rust)
for d in &digits {
    println!("{}", d);
}

// use mutable reference: allows to modify elements
for d in &mut digits {
    *d += 1u64;
    println!("{}", d);
}

// beware: digits is modified due to previous loop
assert_eq!(digits[9], 10);

//  digits ownership is moved due to the underlying construct implementation
for d in digits {
    println!("{}", d);
}

// reset digits
digits = vec![0u64,1,2,3,4,5,6,7,8,9];

// need to add the iter() because digits is not an iterator 
// (i.e. doesn"t implement the Iterator trait )
digits.iter().for_each( |d| println!("{}", d) );

// enumerate() yields tuple
digits.iter().enumerate().for_each( |(d,i)| 
    println!("{} is the {}-th digit", d, i)
);

// note the type specification (<u64>) for hint the compiler about type
digits = vec![0u64,1,2,3,4,5,6,7,8,9];
assert_eq!(digits.iter().sum::<u64>(), 45);

// min & max return an Option<>, no need to unwrap() it
assert_eq!(digits.iter().max().unwrap(), &9);
assert_eq!(digits.iter().min().unwrap(), &0);
assert_eq!(Vec::<u64>::new().iter().min(), None);

// build lipsum vector using split() and collect()
let lipsum: Vec<&str> = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split(" ").collect();
assert_eq!(lipsum.iter().max_by_key(|w| w.len()).unwrap(), &"consectetur");


let a = vec![0,1,2,3];
let b = vec![4,5,6,7];

let zipped: Vec<_> = a.iter().zip(b.iter()).collect();
assert_eq!(zipped, vec![(&0,&4), (&1,&5), (&2,&6), (&3,&7)]);

let end_with_t: Vec<_> = lipsum.iter().filter( |w| w.ends_with("t") ).collect();
assert_eq!(end_with_t, vec![&"sit", &"incididunt", &"ut", &"et"]);

let upper: Vec<_> = lipsum.iter().map( |w| w.to_uppercase() ).collect();
assert_eq!(upper[0], "LOREM");

let words5: Vec<_> = lipsum.iter().filter( |w| w.len() == 5 ).collect();
assert_eq!(words5, vec![&"Lorem", &"ipsum", &"dolor", &"amet,", &"elit,", &"magna"]);


trigo = vec![f64::sin, f64::cos, f64::tan];

let values: Vec<_> = trigo.iter().map( |f| f(std::f64::consts::PI/4f64)).collect();
assert!(f64::abs(values[0] - f64::sqrt(2f64)/2f64) < 10E-6f64);


let a_to_z: Vec<_> = "abcdefghijklmnopqrstuvwxyz".chars().collect();
assert_eq!(a_to_z.len(), 26);
println!("{:?}", a_to_z);

digits = (0..=9).collect();
assert_eq!(digits.len(), 10);

let even: Vec<_> = (0..100).step_by(2).collect();
assert_eq!(even.last().unwrap(), &98);

let first3_binomials = &binomial_coefficients[0..3];
assert_eq!(first3_binomials.len(), 3);
let first4_binomials = &binomial_coefficients[0..=3];
assert_eq!(first4_binomials.len(), 4);

let fibo = Fibonacci::new();

let first_values: Vec<_> = fibo.take(10).collect();
assert_eq!(first_values, vec![1, 2, 3, 5, 8, 13, 21, 34, 55, 89]);


let my_binomials = BinomialCoefficient { coeff: binomial_coefficients.clone() };
assert_eq!(my_binomials[-1], vec![1u16,5,10,10,5,1]);


a_to_z = "abcdefghijklmnopqrstuvwxyz".chars().collect();
let A_to_Z = a_to_z.iter().map( |c| c.to_uppercase() ).collect();


}