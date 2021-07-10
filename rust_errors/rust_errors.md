As I enhanced my knowledge in managing user defined errors in Rust, I decide to share my experience building a CLI application.
Rust error management is powerful, using the *Result<T,E>* construction. But it can be sometimes confusing, specially when associated with the *?* operator.
Using it greatly simplifies the error management in a Rust application, but also introduces a kind of magic, which makes the whole process diffcifult to untangle.

I decided to build my own error management, to better understand how it works, and I didn't resort to custom error crates like *anyhow* or *failure* because I already started using mine. Implementing those could have led to a lot of breaking changes I could simple not to afford.

## The Result<T,E> enum
This enum is described here: https://doc.rust-lang.org/std/result/ and introduces a result which can either be *Ok* or yield an error with the *Err* variant. 
This enum is generic and can be (should be) used whenever it's possible.

Here is a very simple but contrived example:

```rust
// returns the quotient a/b if a is divisible by b or an error message
fn divide(a: u32, b: u32) -> Result<u32, String> {
    if a % b == 0 {
        Ok(a / b)
    } else {
        Err(format!("{} is not divisible by {}", a, b))
    }
}

fn main() {
    assert!(divide(5, 2).is_err());
    assert_eq!(&divide(5, 2).unwrap_err(), "5 is not divisible by 2");

    assert!(divide(6, 2).is_ok());
    assert_eq!(divide(6, 2).unwrap(), 3);    
}
```

Note the different methods to get the core value or the error variant: *unwrap()* or *unwrap_err()*.

## The I/O Result
All I/O Rust standard library functions use a specific error type called *Result* which seems to be confusing at first sight. This is because 
the standard library is using an alias:

```rust
pub type Result<T> = result::Result<T, Error>;
```

to ligthen the I/O methods prototypes. The *Error* defined above is specific to I/O methods which gives an indication of the underlying error, and is actually found in
*std::io::Error*/ 

Here is an exemple:

```rust
fn main() {
    // open a non-existing file
    let f = std::fs::File::open("/foo");
    assert!(f.is_err());

    // analyze error
    let error = f.unwrap_err();
    assert_eq!(error.kind(), std::io::ErrorKind::NotFound);
    println!("error is: {}", error);
}
```

One problem we can ?? here is the lack of context in the last message when printed out:

```
error is: No such file or directory (os error 2)
```

The error message doesn't include the file name being tried to be opened.

## The ? operator
The *?* operator allows you to greatly simplify the error management when calling nested functions or methods. It's a simple and convenient sugar for a *match* expression:

```rust
// opens a file and reads the file or return an I/O error
use std::fs::File;
use std::io::{BufRead, BufReader};

// use std::io::Result on purpose to show it's an alias defined in std::io.
fn read_file(name: &str) -> std::io::Result<()> {
    let file = File::open(name)?;
    let buffer = BufReader::new(file);

    for line in buffer.lines() {
        println!("{}", line?);
    }

    Ok(())
}

fn main() {
    // read ok
    let result = read_file("/var/log/syslog");
    assert!(result.is_ok());

    // read error
    let error = read_file("/foo");
    assert!(error.is_err());
}
```

Without the *?* operator, it's much more verbose (only the first line is converted here):

```rust
let file = File::open(name);
let file = match file {
    Ok(file) => file,
    Err(e) => return Err(e),
};
```

## Nested calls
The power of the *?* operator is that you can use it for all functions returning the same *Result*:

```rust
// read several files but use the same return result
fn read_files() -> std::io::Result<()> {
    read_file("/var/log/syslog")?;
    read_file("/var/log/kern.log")?;

    // only read by root, so returns an error for a non-root user
    read_file("/var/log/boot.log")?;
    Ok(())
}
```

## Returning errors from main()
You can also use the *Result* as a return for the *main()* function. 

```rust
fn main() -> std::io::Result<()> {
    read_files()?;
    Ok(())
}
```

In case of an error, it displays the error message on the console when run:

```
Error: Os { code: 13, kind: PermissionDenied, message: "Permission denied" }
```

## Problem with several error types
Until now, everything is fine and dandy. But things get worse when not all results are of the same type. Suppose you get a file with a list of string regexes and you want to create a vector
of *Regex* structs from the *regex* awesome crate:

```rust
// read a file and create a vector of Regex structs
use regex::Regex;

fn get_regexes(name: &str) -> std::io::Result<Vec<Regex>> {
    let file = File::open(name)?;
    let buffer = BufReader::new(file);
    let v = Vec::new();

    for line in buffer.lines() {
        let expr = line?;
        let re = Regex::new(&expr)?;
    }
    Ok(v)
}
```

This doesn't compile with the pretty cryptic message (at first sight):

```
the trait `std::convert::From<regex::Error>` is not implemented for `std::io::Error`
```

When you have several error types coming from *serde*, *parse* etc this could be a nightmare with lots of compliing errors. 

The solution is to implement the convertion methods and define an enum for storing all error types. You can also add the context by using the *map_err* method which converts all errors to your own defined error.

## Using error crates

## Using your own
Suppose you want to manage, for your CLI project, I/O, regex and serde error in addition to your own. You'd like also to add some context, which is blatantly missing.

This is what I've done in one of my projects:

* define a custom error enum:
```rust
#[derive(Debug, PartialEq)]
pub enum AppCustomErrorKind {
    SeekPosBeyondEof,
    UnsupportedPatternType,
    FileNotUsable,
    FilePathNotAbsolute,
    UnsupportedSearchOption,
    OsStringConversionError,
    PhantomCloneError,
}
```

* define an enum with all possible errors: 
```rust
#[derive(Debug)]
pub enum InternalError {
    Io(io::Error),
    Regex(regex::Error),
    Parse(num::ParseIntError),
    Yaml(serde_yaml::Error),
    Json(serde_json::Error),
    SystemTime(std::time::SystemTimeError),
    Utf8(std::str::Utf8Error),
    Custom(AppCustomErrorKind),
}
```

* define the application error I used, adding a context:
```rust
#[derive(Debug)]
pub struct AppError {
    pub error_kind: InternalError,
    pub msg: String,
}

impl AppError {
    /// A simple and convenient creation of a new application error
    pub fn new_custom(kind: AppCustomErrorKind, msg: &str) -> Self {
        AppError {
            error_kind: InternalError::Custom(kind),
            msg: msg.to_string(),
        }
    }

    /// Convert from an internal error
    pub fn from_error<T: Into<InternalError>>(err: T, msg: &str) -> Self {
        AppError {
            error_kind: err.into(),
            msg: msg.to_string(),
        }
    }
}
```

* implement *fmt:Display* for all internal errors
* implement *std::convert::From* for all internal errors
* define a convenient alias: 

```rust
pub type AppResult<T> = Result<T, AppError>;
```

* finally implement a *context!()* macro to bring the context to the error

You can browse the whole source here: https://github.com/dandyvica/clf/blob/master/src/misc/error.rs

Now, using the *map_err()* method on a *Result<T,E>*, it's easy to add additional information:

```rust
let file = std::fs::File::open(&file_name).map_err(|e| context!(e, "unable to read configuration file: {:?}", &file_name))?;
```

# A final word
The error management is sometimes let behind and tackled in the end of the project. My advice is to start thinking of it right from the beginning, because it often leads to a zillion of changes afterwards.

Hope this helps !