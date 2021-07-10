// returns the quotient a/b if a is divisible by b or an error message
fn divide(a: u32, b: u32) -> std::result::Result<u32, String> {
    if a % b == 0 {
        Ok(a / b)
    } else {
        Err(format!("{} is not divisible by {}", a, b))
    }
}

// opens a file and either the file pointer or the error
use std::fs::{File, read};
use std::io::{BufRead, BufReader, Result};

fn read_file(name: &str) -> std::io::Result<()> {
    let file = File::open(name)?;

    // let file = File::open(name);
    // let file = match file {
    //     Ok(file) => file,
    //     Err(e) => return Err(e),
    // };

    let buffer = BufReader::new(file);

    for line in buffer.lines() {
        println!("{}", line?);
    }

    Ok(())
}

// read several files but use the same return result
fn read_files() -> std::io::Result<()> {
    read_file("/var/log/syslog")?;
    read_file("/var/log/kern.log")?;
    read_file("/var/log/boot.log")?;
    Ok(())
}

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



// fn main() {
//     // read ok
//     let result = read_file("/var/log/syslog");
//     assert!(result.is_ok());

//     // read error
//     let error = read_file("/foo");
//     assert!(error.is_err());
// }

// fn main() {
//     assert!(divide(5, 2).is_err());
//     assert_eq!(&divide(5, 2).unwrap_err(), "5 is not divisible by 2");
//     assert!(divide(6, 2).is_ok());
//     assert_eq!(divide(6, 2).unwrap(), 3);
// }

fn main() -> std::io::Result<()> {
    read_files()?;
    Ok(())
}
