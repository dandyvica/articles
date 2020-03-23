use std::os::raw::c_char;
use std::ffi::{c_void, CStr, CString};

extern "C" { 
    //pub fn malloc(size: usize) -> *mut c_void;
    pub fn dlsym(handle: *mut c_void, func: *const c_char) -> extern "C" fn(c: usize) -> *mut c_void;
    pub fn dlopen(filename: *const c_char, flags: i32) -> *mut c_void;
}

// // this is a simple interface without leveraging from the Rust language bells and whistles
// #[no_mangle]
// pub extern fn add_one(x: u32) -> u32 {
//     x + 1
// }

// // this is a simple interface without leveraging from the Rust language bells and whistles
// // #[no_mangle]
// // pub extern fn rust_malloc(size: usize) -> *mut c_void {
// //     x + 1
// // }

// this is a simple interface without leveraging from the Rust language bells and whistles
// #[no_mangle]
// pub extern fn malloc(size: usize) -> *mut c_void {
//     println!("Calling malloc() in Rust with size = {}", size);
//     let malloc_name = CString::new("malloc").unwrap();
//     let libc = CString::new("/lib/x86_64-linux-gnu/libc.so.6").unwrap();

//     unsafe {
//         let libc_handle = dlopen(libc.as_ptr(), 1);
//         let malloc: extern "C" fn(c: usize) -> *mut c_void = dlsym(libc_handle, malloc_name.as_ptr());
//         malloc(size)
//     }
// }

// strlen() is called using LD_PRELOAD
// #[no_mangle]
// pub extern fn string_length(s: *const c_char) -> usize {
//     println!("Into string_length()");
//     unsafe {
//         let rust_string = CStr::from_ptr(s);
//         rust_string.to_bytes().len()
//     }
// }

#[no_mangle]
pub extern fn strlen(s: *const c_char) -> usize {
    // let rust_string: String;
    // unsafe {
    //     rust_string = CStr::from_ptr(s).to_string_lossy().into_owned();
    // }
    // rust_string.len()

    let c_str = unsafe {
        assert!(!s.is_null());

        CStr::from_ptr(s)
    };

    let r_str = c_str.to_str().unwrap();
    r_str.chars().count()  
}

#[no_mangle]
pub extern fn rand() -> i32 {
    println!("rand() in Rust called");
    11
}

#[no_mangle]
pub extern fn how_many_characters(s: *const c_char) -> usize {
    let c_str = unsafe {
        assert!(!s.is_null());

        CStr::from_ptr(s)
    };

    let r_str = c_str.to_str().unwrap();
    r_str.chars().count()
}





