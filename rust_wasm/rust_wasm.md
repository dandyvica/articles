---
title: WASM in Rust without NodeJS
published: true
description: WASM Rust
tags: #rust #tutorial #beginners #wasm
cover_image: https://thepracticaldev.s3.amazonaws.com/i/ebfvn6ilnzspmv6jrz7p.jpg
---

In this article, I'll talk about how to call Rust WASM methods from JavaScript, but without using NodeJS. Almost the examples I googled so far were only describing using Rust for WASM in NodeJS (but better explained now in the *wasm-bindgen* documentation). I think it's too complicated to grasp the whole idea. It's better (for me at least) to unravel the whole process without bringing too many players in the game.

As Rust is already installed on my Linux machine, I'll be describing how to install Rust and WASM from scratch.

# Prepare Rust

## Reinstall Rust

This is not a mandatory step but as I faced some issues when trying to install WASM, I did reinstall Rust completely:

```command
$ rustup self uninstall
```

Then re-install all the toolchain:

```command
$ curl https://sh.rustup.rs -sSf | sh
```

and verify it's correctly installed:

```command
$ rustc --version
rustc 1.34.2 (6c2484dc3 2019-05-13)
```

Install additional utilities:

```command
$ rustup component add rustfmt
```

```command
$ rustup component add rls rust-analysis rust-src
```

## Install WASM specific extension and utilities

Now it's time to install WASM extension to be able to compile Rust to WASM directly:

```command
rustup target add wasm32-unknown-unknown
```

Then, install the *wasm-gc* utility which allows to strip down the resulting WASM binary from compilation:

```command
$ cargo install wasm-gc
```

## Install *wabt*

The WAT file is the ASCII representation of the binary WASM. You can convert the binary *.wasm* file to a *.wat* ASCII file with the *wasm2wat* command. Follow instructions at https://github.com/WebAssembly/wabt to install the *wabt* toolkit.

## Install *wasm-bindgen*

```console
$ cargo install wasm-bindgen-cli
```

# A simple example: add 2 numbers

## Prepare your project

Now it's time to create a new project:

```command
# --lib for creating a library instead of a binary
$ cargo new --lib wasm_sample
```

and edit the *Cargo.toml* file to add *[lib]* tag:

```toml
[package]
name = "wasm_sample"
version = "0.1.0"
authors = ["dandyvica <dandyvica@gmail.com>"]
edition = "2018"

[dependencies]

[lib]
crate-type =["cdylib"]
```

to mean we want to create a dynamic library.

## A simple Rust WASM function

Let's code a very simple function for the moment:

```rust
// this is a simple interface without leveraging from the Rust language bells and whistles
#[no_mangle]
pub extern fn add(x: u32, y: u32) -> u32 {
    x + y
}
```

## Compile to WASM
You can now compile your code with:

```console
# debug: the target is target/wasm32-unknown-unknown/debug/wasm_sample.wasm
$ cargo build --target wasm32-unknown-unknown
```

or 

```console
# release: the target is target/wasm32-unknown-unknown/release/wasm_sample.wasm
$ cargo build --target wasm32-unknown-unknown --release
```

The resulting *.wasm* file is about 822 KB. Strip it down using *wasm-gc*:

```console
$ wasm-gc target/wasm32-unknown-unknown/debug/wasm_sample.wasm
```

As a result, the *wasm_sample.wasm* is 16 KB. 

Using the *wasm2wat* utility, we can check whether the *add* function is indeed exported:

```console
$ cd target/wasm32-unknown-unknown/debug
$ wasm2wat wasm_sample.wasm -o wasm_sample.wat
$ grep export wasm_sample.wat
  (export "add" (func $add))
  (export "__rustc_debug_gdb_scripts_section__" (global 3))
```

## Glue it with HTML and JavaScript
Create a `www` directory in your Rust project root structure:

```console
$ mkdir www
$ cd www
```

and create an `index.html` file:

```html
<!DOCTYPE html>
<html>
  <head>
    <script src="wasm_sample.js"></script>
  <head>
  <body>
    <form onSubmit="return false">
      Enter X: <input type="number" name="X" required><br>
      Enter Y: <input type="number" name="Y" required><br><br>
      <input 
        type="submit" 
        value="X+Y=" 
        onClick="result.innerText = wasm_add(X.value,Y.value)">
      <label id="result"></label>   
    </form>       
  </body>
<html>
```

and create the `wasm_sample.js` JavaScript file:

```js
// use this JS API to load the WASM module and start using it in a streaming mode
// i.e. without having to wait
WebAssembly.instantiateStreaming(fetch("wasm_sample.wasm"))
    .then(wasmModule => {
        // this saves the exported function from WASM module for use in JS
        wasm_add = wasmModule.instance.exports.add;
    });
```

Also, copy the WASM module to your `www` directory to rule out directory hassles:

```console
$ cp ../target/wasm32-unknown-unknown/debug/wasm_sample.wasm .
```

## Run a web server
On Linux, a simple web server is available through Python by:

```console
$ python3 -m http.server
```

but this implementation doesn't include the `application/wasm` mime type needed to import the WASM module.

You can find an example on GitHub gist to handle WASM mime types. Save the following into a `server.py` file:

```python
import http.server
import socketserver

PORT = 8000

Handler = http.server.SimpleHTTPRequestHandler
Handler.extensions_map.update({
    '.wasm': 'application/wasm',
})

socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.allow_reuse_address = True
    print("serving at port", PORT)
    httpd.serve_forever()
```

Then starts the web server:

```console
$ python3 server.py
```
Then, start your favorite browser supporting WASM et head to http://localhost:8000

![WASM add](https://thepracticaldev.s3.amazonaws.com/i/v1phz09zooyvqwx94fpv.png)

# Using the *wasm-bindgen* crate

The previous example exposed a Rust function, but without leveraging from Rust power, like exchanging strings or structures between JS and Rust. In order to achieve that, you'll need to import the `wasm-bindgen` crate in your `Cargo.toml`.

As stated in https://rustwasm.github.io/wasm-bindgen/:

> _this project allows JS/wasm to communicate with strings, JS objects, > classes, etc, as opposed to purely integers and floats_.

Now we're going to pass a string from JS to Rust back and forth.

## Add *wasm-bindgen* crate

Add the dependency to *wasm-bindgen* in the *Cargo.toml* file:

```toml
[dependencies]
wasm-bindgen = "0.2.45"
```

## Modify the *lib.rs* source file

```rust
extern crate wasm_bindgen;
use wasm_bindgen::prelude::*;

// Reverse a string coming from JS 
#[wasm_bindgen]
pub fn reverse(s: String) -> String {
    s.chars().rev().collect::<String>()
}
```

And compile:

```command
$ cargo build --target wasm32-unknown-unknown
```

## Bind with Rust 
Next step is to run *wasm-bindgen* to make use of high-level interactions between WASM modules and JavaScript:

```console
$ cd target/wasm32-unknown-unknown/debug
$ wasm-bindgen --target web --no-typescript --out-dir . wasm_sample.wasm
```

This will create 2 WASM files: *wasm_sample.wasm* and *wasm_sample_bg.wasm*. This is the last one we're gonna use.

## Strip down the WASM binary

```command
$ wasm-gc wasm_sample_bg.wasm
```

and copy the WASM binary (*wasm_sample_bg.wasm*) and the generated JS module (*wasm_sample.js*) into the *www* directory

## Edit the *index.html* file

Finally, edit the *index.html* file as follows:

```html
<html>
  <head>
    <meta content="text/html;charset=utf-8" http-equiv="Content-Type"/>
  </head>
  <body>
    <!-- Note the usage of `type=module` here as this is an ES6 module -->
    <script type="module">
      import { reverse, default as init } from './wasm_sample.js';

      async function run() {
        await init('./wasm_sample_bg.wasm');

        // make the function available to the browser
        window.reverse = reverse;
      }

      run();
    </script>
    
    <form onSubmit="return false">
        <textarea rows="40" cols="50" name="lipsum">
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.         
Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
        </textarea><br> 
        <input 
            type="submit" 
            value="Reverse string" 
            onClick="lipsum.value = reverse(lipsum.value)">
    </form> 
  </body>

</html>
```

It will reverse the whole phrase in the textarea:

![WASM](https://thepracticaldev.s3.amazonaws.com/i/zvd2qrthgszupqtz7l89.png)
![WASM](https://thepracticaldev.s3.amazonaws.com/i/83tcg6frew6axmrjz5mk.png)

Hope this helps !

> Photo by Markus Spiske on Unsplash