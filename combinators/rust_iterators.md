---
title: Using Rust standard iterators
published: true
description: 
tags: #rust #tutorial
cover-image: https://dev-to-uploads.s3.amazonaws.com/i/j0njdtrt3gn4ptv71p2f.jpg
---

Today, I'll tackle Rust standard iterators, which can be browsed here: [Rust Iterators](https://doc.rust-lang.org/std/iter/trait.Iterator.html) 

In you ever read this page, you've probably stumbled upon a list of methods along with some examples, but even after reading this full page, you may have wondered: how to use all these methods ?

Because the examples are based, for the most part, on a vector of integers (which by the way implement the _Copy_ trait), it's pretty easy to use with such an iterable. But once you have a more complicated iterator like a vector of structs, this might be more tedious to use.

That's why I wrote this article.

As the base for my examples, I've use the Mendeleiev periodic list of elements available as a CSV file here: https://gist.github.com/GoodmanSciences/c2dd862cd38f21b0ad36b8f96b4bf1ee (beware to fix lines which contain spaces betweens fields, as Rust might crash when loading the CSV).

I've create a simple function to load the data into a struct, whose members map (snake case though) the CSV column names:

```rust
pub fn load_as_vector() -> Result<Vec<Element>, Box<dyn Error>> {
    // load CSV
    let reader = std::fs::File::open("elements.csv").unwrap();
    let mut rdr = csv::Reader::from_reader(reader);

    // create a vector of structs
    let mut v: Vec<Element> = Vec::new();

    for result in rdr.deserialize() {
        let record: Element = result?;
        v.push(record);
    }

    Ok(v)
}
```

The vector is loaded using this dedicated method (you can find the whole code here: https://github.com/dandyvica/articles/tree/master/combinators)
```rust
let v = element::load_as_vector()?;
```

I didn't respect the alphabetic order of all the methods, I rather adopted an incremental approach, with the simplest ones in the beginning of the article. I tried to express what the method is representing for the vector data, instead of writing its definition which you can get anyway. I also _unwrap()_ the results when possible, because a lot of iterators methods usually return an *Option<T>* type. 

I also didn't cover all the methods, by lack of time. If you get ideas on how to add other examples for this missing methods, feel free to reach out ! In addition, the following examples are probably not optimized and some better combination of iterators should exist.

Beware I'm by no means a chemical engineer, I used this material just to illustrate my article.

## Iterator methods

* _count()_: there're 118 elements in the Mendeleiev table

```rust
let n = v.iter().count();
assert_eq!(n, 118);
```

* _last()_: **Oganesson** is the last element
```rust
let last_element = v.iter().last().unwrap();
assert_eq!(last_element.element, "Oganesson");
```

* _nth()_: **Uranium** is the 92th element (vector is indexing from 0), but there's not a 119th element
```rust
let uranium = v.iter().nth(91).unwrap();
assert_eq!(uranium.element, "Uranium");
assert!(v.iter().nth(118).is_none());
```

* _map()_:: **Carbon** is the 6th element
```rust
let mut mapped = v
    .iter()
    .map(|x| (x.atomic_number, x.element.as_ref(), x.symbol.as_ref()));
assert_eq!(mapped.nth(5).unwrap(), (6u8, "Carbon", "C"));
```
* _collect()_: create a vector of elements' names
```rust
let names: Vec<_> = v.iter().map(|x| &x.element).collect();
assert_eq!(names[0..2], ["Hydrogen", "Helium"]);
```

* _take()_: the 2 first elements are **Hydrogen** and **Helium**
```rust
let first_2: Vec<_> = v.iter().take(2).map(|x| x.element.clone()).collect();
assert_eq!(first_2, ["Hydrogen", "Helium"]);
```

* _take_while()_: there're 10 elements with less than 10 neutrons
```rust
let less_than_10e = v.iter().take_while(|x| x.number_of_neutrons <= 10);
assert_eq!(less_than_10e.count(), 10);
```

* _any()_: there's at least one element with more than 50 electrons
```rust
assert!(v.iter().any(|x| x.number_of_neutrons > 50));
```

* _all()_: all elements have their symbol composed by 1 or 2 letters (e.g.: **C** or **Na**)
```rust
assert!(v.iter().all(|x| x.symbol.len() == 1 || x.symbol.len() == 2));
```

* _cycle()_: when cycling through elements, **Lithium** is the 120th element
```rust
assert_eq!(v.iter().cycle().nth(120).unwrap().element, "Lithium");
```

* _find()_: **Helium** is the first element whose name ends with _ium_
```rust
let helium = v.iter().find(|x| x.element.ends_with("ium")).unwrap();
assert_eq!(helium.element, "Helium");
```

* _filter()_ and *for_each()*: there're 11 gases
```rust
let gases: Vec<_> = v.iter().filter(|x| x.phase == "gas").collect();
assert_eq!(gases.iter().count(), 11);
v.iter()
    .filter(|x| x.phase == "gas")
    .for_each(|x| println!("{:?}", x.element));
// gives:
// "Hydrogen"
// "Helium"
// "Nitrogen"
// "Oxygen"
// "Fluorine"
// "Neon"
// "Chlorine"
// "Argon"
// "Krypton"
// "Xenon"
// "Radon"
```

* _filter_map()_: there're 37 radioactive elements
```rust
let radioactives: Vec<_> = v
    .iter()
    .filter_map(|x| x.radioactive.as_ref())
    .filter(|x| **x == YN::yes)
    .collect();
assert_eq!(radioactives.iter().count(), 37);
```

* _enumerate()_: the last element index is 117
```rust
let (i, _) = v.iter().enumerate().last().unwrap();
assert_eq!(i, 117);
```

* *skip_while()*: the first non-gas is **Lithium**
```rust
let first_non_gas = v.iter().skip_while(|x| x.phase == "gas" ).next().unwrap();
assert_eq!(first_non_gas.element, "Lithium");
```

* _zip()_: Uranium mass number is 238
```rust
let neutrons = v.iter().map(|x| x.number_of_neutrons);
let protons = v.iter().map(|x| x.number_of_protons);
let mass_numbers: Vec<_> = neutrons.zip(protons).map(|(x, y)| x + y).collect();
assert_eq!(mass_numbers[91], 238);
```

* _chain()_: when listing gases and solids, **Lithium** is the first element, **Radon** the last
```rust
let all_gases = v.iter().filter(|x| x.phase == "gas");
let all_solids = v.iter().filter(|x| x.phase == "solid");
let gases_and_solids: Vec<_> = all_solids.chain(all_gases).collect();
assert_eq!(gases_and_solids.iter().nth(0).unwrap().element, "Lithium");
assert_eq!(gases_and_solids.iter().last().unwrap().element, "Radon");
```

* _position()_: searches for the **Potassium** element
```rust
let potassium = v.iter().position(|x| x.element == "Potassium").unwrap();
assert_eq!(v[potassium].symbol, "K");
```

* _rposition()_: **Radon** is the last gas
```rust
let last_gas = v.iter().rposition(|x| x.phase == "gas").unwrap();
assert_eq!(v[last_gas].element, "Radon");
```

* _max_by()_: the heaviest non-artificial element is **Uranium**
```rust
use std::cmp::Ordering;
let cmp = |x: &Element, y: &Element| -> Ordering {
    if x.atomic_mass < y.atomic_mass {
        Ordering::Less
    } else if x.atomic_mass > y.atomic_mass {
        Ordering::Greater
    } else {
        Ordering::Equal
    }
};

let heaviest = v
    .iter()
    .filter(|x| x.phase != "artificial")
    .max_by(|x, y| cmp(x, y))
    .unwrap();
assert_eq!(heaviest.symbol, "U");
```

* _rev()_: the last element when reversing the vector is **Hydrogen**
```rust
let hydrogen = v.iter().rev().last().unwrap();
assert_eq!(hydrogen.symbol, "H");
```

* _max_by_key()_: the longuest element's name is **Rutherfordium**
```rust
let longuest = v.iter().max_by_key(|x| x.element.len()).unwrap();
assert_eq!(longuest.element, "Rutherfordium");
```

* _max_(): **Carbon** was the first element discovered, **Tennessine** the last
```rust
//use std::cmp::Ordering;

impl Ord for Element {
    fn cmp(&self, other: &Self) -> Ordering {
        if self.year < other.year {
            Ordering::Less
        } else if self.year > other.year {
            Ordering::Greater
        } else {
            Ordering::Equal
        }
    }
}

impl PartialOrd for Element {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl PartialEq for Element {
    fn eq(&self, other: &Self) -> bool {
        self.year == other.year
    }
}

impl Eq for Element {}

let first_discovered = v.iter().min().unwrap();
assert_eq!(first_discovered.element, "Carbon");
let last_discovered = v.iter().max().unwrap();
assert_eq!(last_discovered.element, "Tennessine");
```

Hope this helps ! Feel free to comment.

> Photo by Bill Oxford on Unsplash