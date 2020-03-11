# just create the main.rs from the .md file
to_print = False

header = """
use std::error::Error;

mod element;
use element::{Element, YN};

fn main() -> Result<(), Box<dyn Error>> {
    let mut v = element::load_as_vector()?;
"""
print(header)

for line in open('README.md'):
    s = line.strip()

    if s == "```rust":
        to_print = True
        print("\n")
    elif s == "```":
        to_print = False
    elif to_print:
        print(f"\t{s}")

print("Ok(())}")
