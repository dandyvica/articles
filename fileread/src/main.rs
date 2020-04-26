use std::fs::File;
use std::io::{BufRead, BufReader, Read, Cursor};
use std::net::Ipv4Addr;
use std::str::FromStr;

use memmap::Mmap;
use byteorder::{LittleEndian, BigEndian, ReadBytesExt};

// read all file data, split each line, parse each line
fn read_all<T: FromStr>(file_name: &str) -> Vec<Result<T, <T as FromStr>::Err>> {
    std::fs::read_to_string(file_name)
        .expect("file not found!")
        .lines()
        .map(|x| x.parse())
        .collect()
}

// Calls *func()* on each line
fn read_iter(file_name: &str, func: fn(&str)) {
    let file = File::open(file_name).expect("file not found!");
    let reader = BufReader::new(file);

    for line in reader.lines() {
        func(&line.unwrap());
    }
}

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

// maps the file to memory
fn read_mmap(file_name: &str) -> Result<(), std::io::Error> {
    // open target file
    let file = File::open(&file_name)?;

    // create a memmap struct. After that, mmap variable maps directly file contents
    let mmap = unsafe { Mmap::map(&file)? };

    for s in mmap.split(|x| *x == 0x10) {
        println!("{:?}", std::str::from_utf8(&s).unwrap());
    }

    Ok(())
}

// read PNG file image width and height
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

fn main() -> Result<(), std::io::Error> {
    //println!("{:?}", read_all::<Ipv4Addr>("ipv4.txt"));
    //read_iter("ipv4.txt", |s| println!("{}", s));
    //read_line("ipv4.txt", |s| print!("{}", s))?;
    //read_split("ipv4.txt", |s| print!("{:?}", std::str::from_utf8(&s).unwrap()))?;
    //read_mmap("ipv4.txt")?;
    read_png("sample.png");

    Ok(())
}
