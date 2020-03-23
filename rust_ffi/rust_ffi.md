---
title: How to call Rust functions from C on Linux
published: true
description: How to call Rust functions from C
tags: #rust #tutorial #ffi #c
cover_image: https://thepracticaldev.s3.amazonaws.com/i/7cnl0shhh5ddcd3tge8o.jpg
---


Calling Rust from C is nor complicated neither really straightforward. I decided to experiment this feature with a list of functions callable from C for nearly each possible C type.

The Rust module is compiled as a dynamic library, by setting the *[lib]* tag in the *Cargo.toml* file:

```toml
[lib]
crate-type =["cdylib"]
```

The C file is compiled as a 64-bit executable, dynamically linked at runtime with the previous library.

All C-types have their equivalence in the Rust type system, using the *FFI* module or the *libc* crate (not used here).

## Rust functions

All Rust functions should be marked as *#[no_mangle]* and *extern* because they will be marked as exported in the resulting library.

The Rust source file is using a simple macro to define most of the functions (this macro is found in the Rust book) to avoid repetitive code:

```rust
use std::ffi::{c_void, CStr};
use std::os::raw::c_char;
use std::slice;

// A Rust struct mapping the C struct
#[repr(C)]
#[derive(Debug)]
pub struct RustStruct {
    pub c: char,
    pub ul: u64,
    pub c_string: *const c_char,
}

macro_rules! create_function {
    // This macro takes an argument of designator `ident` and
    // creates a function named `$func_name`.
    // The `ident` designator is used for variable/function names.
    ($func_name:ident, $ctype:ty) => {
        #[no_mangle]
        pub extern "C" fn $func_name(v: $ctype) {
            // The `stringify!` macro converts an `ident` into a string.
            println!(
                "{:?}() is called, value passed = <{:?}>",
                stringify!($func_name),
                v
            );
        }
    };
}

// create simple functions where C type is exactly mapping a Rust type
create_function!(rust_char, char);
create_function!(rust_wchar, char);
create_function!(rust_short, i16);
create_function!(rust_ushort, u16);
create_function!(rust_int, i32);
create_function!(rust_uint, u32);
create_function!(rust_long, i64);
create_function!(rust_ulong, u64);
create_function!(rust_void, *mut c_void);

// for NULL-terminated C strings, it's a little bit clumsier
#[no_mangle]
pub extern "C" fn rust_string(c_string: *const c_char) {
    // build a Rust string from C string
    let s = unsafe { CStr::from_ptr(c_string).to_string_lossy().into_owned() };

    println!("rust_string() is called, value passed = <{:?}>", s);
}

// for C arrays, need to pass array size
#[no_mangle]
pub extern "C" fn rust_int_array(c_array: *const i32, length: usize) {
    // build a Rust array from array & length
    let rust_array: &[i32] = unsafe { slice::from_raw_parts(c_array, length as usize) };
    println!(
        "rust_int_array() is called, value passed = <{:?}>",
        rust_array
    );
}

#[no_mangle]
pub extern "C" fn rust_string_array(c_array: *const *const c_char, length: usize) {
    // build a Rust array from array & length
    let tmp_array: &[*const c_char] = unsafe { slice::from_raw_parts(c_array, length as usize) };

    // convert each element to a Rust string
    let rust_array: Vec<_> = tmp_array
        .iter()
        .map(|&v| unsafe { CStr::from_ptr(v).to_string_lossy().into_owned() })
        .collect();

    println!(
        "rust_string_array() is called, value passed = <{:?}>",
        rust_array
    );
}

// for C structs, need to convert each individual Rust member if necessary
#[no_mangle]
pub unsafe extern "C" fn rust_cstruct(c_struct: *mut RustStruct) {
    let rust_struct = &*c_struct;
    let s = CStr::from_ptr(rust_struct.c_string)
        .to_string_lossy()
        .into_owned();

    println!(
        "rust_cstruct() is called, values passed = <{} {} {}>",
        rust_struct.c, rust_struct.ul, s
    );
}
```

A mere *cargo build* will compile this *lib.rs* file and place the result in *target/debug* subdirectory of the Rust project directory. My lib is called *librustcalls.so*

You can look at exported functions with the *nm* command:

```command
$ nm --defined-only  -D ./rustcalls/target/debug/librustcalls.so 
000000000000b5e0 T rust_char
000000000000b3b0 T rust_cstruct
0000000000016740 T rust_eh_personality
000000000000ba20 T rust_int
000000000000b140 T rust_int_array
000000000000bc40 T rust_long
000000000000b800 T rust_short
000000000000b010 T rust_string
000000000000b240 T rust_string_array
000000000000bb30 T rust_uint
000000000000bd50 T rust_ulong
000000000000b910 T rust_ushort
000000000000be60 T rust_void
000000000000b6f0 T rust_wchar
```

## C functions

C function declarations are necessary to link the external library (at runtime) compiled with Rust.

Compilation is done by:

```command
$ gcc -g call_rust.c -o call_rust -lrustcalls -L./rustcalls/target/debug
```
where:

* *-g* is for including symbols for debugging with *gdb*
* *-o call_rust* will create *call_rust* as the executable file
* *-lrustcalls* tells the compiler to look for function definitions in the *librustcalls.so* shared lib file
* *-L./rustcalls/target/debug* tells the compiler to look into this directory for the previous file

*call_rust.c* is this file:

```c
// compile with gcc -g call_rust.c -o call_rust -lrustcalls -L./rustcalls/target/debug

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wchar.h>

// sample struct to illustrate passing a C-struct to Rust
struct CStruct {
    char c;
    unsigned long ul;
    char *s;
};

// functions called in the Rust library
extern void rust_char(char c);
extern void rust_wchar(wchar_t c);
extern void rust_short(short i);
extern void rust_ushort(unsigned short i);
extern void rust_int(int i);
extern void rust_uint(unsigned int i);
extern void rust_long(long i);
extern void rust_ulong(unsigned long i);
extern void rust_string(char *s);
extern void rust_void(void *s);
extern void rust_int_array(const int *array, int length);
extern void rust_string_array(const char **array, int length);
extern void rust_cstruct(struct CStruct *c_struct);

int main() {
    // pass char to Rust
    rust_char('A');
    rust_wchar(L'ζ');

    // pass short to Rust
    rust_short(-100);
    rust_ushort(100);

    // pass int to Rust
    rust_int(-10);
    rust_uint(10);

    // pass long to Rust
    rust_long(-1000);
    rust_ulong(1000);    

    // pass a NULL terminated string
    rust_string("hello world");

    // pass a void* pointer
    void *p = malloc(1000);
    rust_void(p);  

    // pass an array of ints
    int digits[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}; 
    rust_int_array(digits, 10);

    // pass an array of c strings
    const char *words[] = { "This", "is", "an", "example"};
    rust_string_array(words, 4);   

    // pass a C struct
    struct CStruct c_struct;
    c_struct.c = 'A';
    c_struct.ul = 1000;
    c_struct.s = malloc(20);
    strcpy(c_struct.s, "0123456789");
    rust_cstruct(&c_struct);

    // don't forget to clean up ;-)
    free(p); 
    free(c_struct.s);

    return 0;
}
```

You can look at linked libraries using the *ldd* command:

```command
$ ldd call_rust
        linux-vdso.so.1 (0x00007ffe6d69c000)
        librustcalls.so => not found
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007fb695054000)
        /lib64/ld-linux-x86-64.so.2 (0x00007fb695648000)
```

*librustcalls.so* is reported *not found* because not in the standard paths for shared libs. It's necessary to tell the linker where to find this file, using the *LD_LIBRARY_PATH* environment variable:

```command
$ LD_LIBRARY_PATH=rustcalls/target/debug ldd call_rust
        linux-vdso.so.1 (0x00007ffcb8f62000)
        librustcalls.so => rustcalls/target/debug/librustcalls.so (0x00007f60a975b000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f60a936a000)
        libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f60a9166000)
        librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f60a8f5e000)
        libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f60a8d3f000)
        libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f60a8b27000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f60a9b97000)
```

Now to execute:

```command
$ LD_LIBRARY_PATH=rustcalls/target/debug ./call_rust  
"rust_char"() is called, value passed = <'A'>
"rust_wchar"() is called, value passed = <'ζ'>
"rust_short"() is called, value passed = <-100>
"rust_ushort"() is called, value passed = <100>
"rust_int"() is called, value passed = <-10>
"rust_uint"() is called, value passed = <10>
"rust_long"() is called, value passed = <-1000>
"rust_ulong"() is called, value passed = <1000>
rust_string() is called, value passed = <"hello world">
"rust_void"() is called, value passed = <0x55f0a68f17d0>
rust_int_array() is called, value passed = <[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]>
rust_string_array() is called, value passed = <["This", "is", "an", "example"]>
rust_cstruct() is called, values passed = <A 1000 0123456789>
```

Hope this helps !

> Photo by Deanna Ritchie on Unsplash