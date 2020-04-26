---
title: Different ways of reading files in Rust
published: false
tags: #rust #tutorial #beginners
cover_image: https://thepracticaldev.s3.amazonaws.com/i/rr0qtuw3thsl27jsznsm.jpg
---

This time, I'd like to share my experience on the different ways to read files in Rust. Different methods can be used, each one having its own drawbacks.

## Reading ASCII files
Basically, there're 3 ways of reading ASCII files in Rust, and an additional possibly more harmful.

1.loading the entire file in a `String`.

This is done using the `std::fs::read_to_string()` method. If you're familiar with Python or Ruby, this method is as convenient as Python's `read()` function or Ruby's `File.read()` methods. Combined with the power of generics, you can easily build a vector of structs, matching the data type in a file:

```rust
// Loads an entire file of ip addresses as a Vector of Result<Ipv4Addr> structs
fn read_all<T: FromStr>(file_name: &str) -> Vec<Result<T, <T as FromStr>::Err>> {
    std::fs::read_to_string(file_name)
        .expect("file not found!")
        .lines()
        .map(|x| x.parse())
        .collect()
}

let addr = read_all::<Ipv4Addr>("ipv4.txt");
```

2.using the `lines()` iterator.

This is another easy method for reading a file line by line, using the `lines()` iterator. This iterator operates on a `BufReader` created from a `File` object. So a `BufReader` structure needs to be created for this to be used.

This example function calls a closure on each line:

```rust
// Calls *func()* on each line
fn read_iter(file_name: &str, func: fn(&str)) {
    let file = File::open(file_name).expect("file not found!");
    let reader = BufReader::new(file);

    for line in reader.lines() {
        func(&line.unwrap());
    }
}
```
This method is useful for small files but not really appropriate for very large files because each iteration incurs a `String::new()` allocation.


3.using the `read_line()` function.

The `read_line()` function can make use of the same `String` buffer, without reallocating on each iteration. But due to the way Rust iterators work, we can't build a standard iterator here. We have to use a mere `loop` construct, and stop it when the `read_line()` function returns `Ok(0)`, which means EOF:

```rust
// Reuse the same String buffer
fn read_line(file_name: &str, func: fn(&str)) -> Result<(), std::io::Error> {
    // open target file
    let file = File::open(&file_name)?;

    // uses a reader buffer
    let mut reader = BufReader::new(file);
    let mut line = String::new();

    loop {
        match reader.read_line(&mut line) {
            Ok(bytes_read) => {
                // EOF: save last file address to restart from this address for next run
                if bytes_read == 0 {
                    break;
                }

                func(&line);

                // do not accumulate data
                line.clear();
            }
            Err(err) => {
                return Err(err);
            }
        };
    }

    Ok(())
}
```
Don't forget to clear the buffer after you've got the data, otherwise buffer will grow unexpectedly.

One can also use the `split()` iterator, which incurs the same drawback than `lines()`: it allocates a
`Vec<u8>` on each iteration.

```rust
// Reuse the same Vec<u8> buffer
fn read_split(file_name: &str, func: fn(&[u8])) -> Result<(), std::io::Error> {
    // open target file
    let file = File::open(&file_name)?;

    // uses a reader buffer
    let reader = BufReader::new(file);

    // use a for loop construct
    for line in reader.split(0x10) {
        func(&line?);
    }
    Ok(())
}
```

4.use `mmap()`api

For an explantion of this system call, have a look to https://en.wikipedia.org/wiki/Mmap.
As it's not included in the standard Rust library, you can use the `memmap` crate:

```rust
// Maps the file to memory
fn read_mmap(file_name: &str) -> Result<(), std::io::Error> {
    // open target file
    let file = File::open(&file_name)?;

    // create a memmap struct. After that, mmap variable maps directly file contents
    let mmap = unsafe { Mmap::map(&file)? };

    // use from_utf8() to convert to an UTF8 Rust string
    for s in mmap.split(|x| *x == 0x10) {
        println!("{:?}", std::str::from_utf8(&s).unwrap());
    };

    Ok(())
}
```

Beware this is not a foolproof process, as if the file is changed, you can could get a `SIGBUS` error.

## Reading binary files
Reading a binary file is not really different from an ASCII file. But you should be aware of any endianess issues, and use the `byteorder` crate, although not really related to the Rust read methods *per se*.

This is an example of a PNG file header reading, to get image width & height:

```rust
// Read PNG file image width and height
fn read_png(file_name: &str) -> Result<(), std::io::Error> {
    const BUFFER_SIZE: usize = 256;

    // open target file
    let mut file = File::open(&file_name)?;

    // we'll use this buffer to get data
    let mut buffer = [0; BUFFER_SIZE];

    // reader PNG header of 8 bytes
    let _ = file.by_ref().take(8).read(&mut buffer)?;
    assert_eq!(&buffer[1..4], "PNG".as_bytes());

    // read IHDR chunk
    let chunk_size = file.read_u32::<BigEndian>().unwrap();
    let _ = file.by_ref().take(4).read(&mut buffer)?;
    assert_eq!(&buffer[0..4], "IHDR".as_bytes());

    let image_width = file.read_u32::<BigEndian>().unwrap();
    let image_height = file.read_u32::<BigEndian>().unwrap();
    println!("image is W={} x H={}", image_width, image_height);

    Ok(())
}
```

Hope this helps !

> Photo by Maarten van den Heuvel on Unsplash