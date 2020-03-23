extern crate wasm_bindgen;
use wasm_bindgen::prelude::*;

// Reverse a string coming from JS 
#[wasm_bindgen]
pub fn reverse(s: String) -> String {
    s.chars().rev().collect::<String>()
}

// more idiomatic rust code
#[wasm_bindgen]
pub fn add(x: u32, y: u32) -> u32 {
    x + y
}