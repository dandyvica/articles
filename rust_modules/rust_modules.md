---
title: Understanding Rust modules
published: true
description: 
tags: #rust #tutorial
cover_image: https://dev-to-uploads.s3.amazonaws.com/i/lm2rtpmr9937t18ohm9w.jpg
---

If you ever fought against Rust modules, you probably already googled for terms such as "*rust modules*" or "*rust modules structure*". And you probably stumbled upon the Rust book. But after reading the articles, you're maybe in a situation were you still don't grab the whole idea, and according to the new article called [Path Clarity](https://doc.rust-lang.org/edition-guide/rust-2018/module-system/path-clarity.html):

> ... why it's so confusing to many: while there are simple and consistent rules defining the module system, their consequences can feel inconsistent, counterintuitive and mysterious.

For modules defined inside a source *.rs* file, that's OK. But if you're a seasoned developer, you're used to break down your code into different source files.

I wrote this article, with a simple example, to better understand the Rust module system. I'm referring to the last version of Rust called Rust 2018.

So let's create  a simple project structure using *cargo*, with a hierarchical structure

```console
$ cargo new rust_modules --bin
```

Let's create a simple module hierarchical structure based on maths:

```rust
// main.rs
mod math {
    pub mod arithmetic {
        pub fn add(x: i32, y: i32) -> i32 {
            x + y
        }
        pub fn mul(x: i32, y: i32) -> i32 {
            x * y
        }
    }

    pub mod trigonometry {
        pub mod ordinary {
            pub fn sin(x: f32) -> f32 {
                x.sin()
            }
            pub fn cos(x: f32) -> f32 {
                x.cos()
            }
        }

        pub mod hyperbolic {
            pub fn sinh(x: f32) -> f32 {
                (x.exp() - (-x).exp()) / 2f32
            }
            pub fn cosh(x: f32) -> f32 {
                (x.exp() + (-x).exp()) / 2f32
            }
        }
    }
}

fn main() {
    use math::arithmetic::{add, mul};
    use math::trigonometry::hyperbolic::{cosh, sinh};
    use math::trigonometry::ordinary::{cos, sin};
}
```

This code compiles because it's located in the same source file. Things are getting more complicated if you want to split the module into different source files:

```rust
// src/math.rs or src/math/mod.rs
pub mod arithmetic {
    pub fn add(x: i32, y: i32) -> i32 {
        x + y
    }
    pub fn mul(x: i32, y: i32) -> i32 {
        x * y
    }
}

pub mod trigonometry {
    pub mod ordinary {
        pub fn sin(x: f32) -> f32 {
            x.sin()
        }
        pub fn cos(x: f32) -> f32 {
            x.cos()
        }
    }

    pub mod hyperbolic {
        pub fn sinh(x: f32) -> f32 {
            (x.exp() - (-x).exp()) / 2f32
        }
        pub fn cosh(x: f32) -> f32 {
            (x.exp() + (-x).exp()) / 2f32
        }
    }
}
```

You can put the internal of the math module into a single file in *src/math.rs* (filename has the same name of the module without extension) or in *src/math/mod.rs*. Then the
*main.rs* becomes:

```rust
// math module internals is either in src/math.rs or src/math/mod.rs
mod math;

fn main() {
    use math::arithmetic::{add, mul};
    use math::trigonometry::hyperbolic::{cosh, sinh};
    use math::trigonometry::ordinary::{cos, sin};
}
```

You can even use the new path attribute to move your source code wherever you want:

```rust
// the source code containing the math module is moved to /tmp/math.rs
#[path="/tmp/math.rs"]
mod math;

fn main() {
    use math::arithmetic::{add, mul};
    use math::trigonometry::hyperbolic::{cosh, sinh};
    use math::trigonometry::ordinary::{cos, sin};
}
```

So using the *mod.rs* technique, you could breakdown the *math* module into several source files:

```
├── main.rs
└── math
    ├── arithmetic.rs
    ├── mod.rs
    └── trigonometry
        ├── hyperbolic.rs
        ├── mod.rs
        └── ordinary.rs
```

with the following *mod.rs* files:

```rust
// src/math/mod.rs
pub mod arithmetic;
pub mod trigonometry;
```
```rust
// src/math/trigonometry/mod.rs
pub mod hyperbolic;
pub mod ordinary;
```

I should say this is not the most straightforward module strategy, but once you get acquainted to it, it feels more natural. So the key takeaways are:

* the *mod* & *use* keywords are like *import* or *require* in popular languages
* a module named *mymod* reflects either a filename similar to *mymod.rs* or *mymod/mod.rs*


> Photo by Timo Volz on Unsplash