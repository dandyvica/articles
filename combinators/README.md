Today, I'll tackle Rust standard iterator, which can be browsed here: 

In you ever read this page, you've probably stumbled upon a list of methods along with some examples, but even after reading this full page, you may have wondered: how to use all these methods ?
Because the examples are based, for the most part, on a vector of integers which implements the _Copy_ trait, it's pretty easy to use with integers. But once you have a more complicated iterator like a vector of structs, this might be more tedious to use.

That's why I've created this article.

As the base for my examples, I've use the Mendeleiv periodic list of elements available as a CSV file here: https://gist.github.com/GoodmanSciences/c2dd862cd38f21b0ad36b8f96b4bf1ee 

For the sake of simplicity, I don't show here the full code for loading all data into:

* a vector of structs _v_
* a hash of structs _h_

The main struct is maaping the first line of the CSV file, which can be extracted simply like this:

```console
$ head -1 elements.txt | tr ',' '\n'
```

I've used the CSV crate with serde --

* _count()_: number of elements:

```rust
let n = v.iter().count();
assert_eq!(n, 118);
```

* _any()_: 

```rust
assert!(v.iter().any(|x| x.ends_with("ium")));
```

* _by_ref_

* _chain()_

* _find()_: beware this method returns Some(element) or None. So use of something like _unwrap_or()_ is more than useful

```rust
let helium = v.iter().find(|x| x.ends_width("ium")).unwrap_or(None);
assert_eq!(helium.element, "Helium");
```

```rust
```

```rust
```

```rust
```

```rust
```

```rust
```

```rust
```

```rust
```

```rust
```
