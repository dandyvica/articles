// mod math {
//     pub mod arithmetic {
//         pub fn add(x: i32, y: i32) -> i32 {
//             x + y
//         }
//         pub fn mul(x: i32, y: i32) -> i32 {
//             x * y
//         }
//     }

//     pub mod trigonometry {
//         pub mod ordinary {
//             pub fn sin(x: f32) -> f32 {
//                 x.sin()
//             }
//             pub fn cos(x: f32) -> f32 {
//                 x.cos()
//             }
//         }

//         pub mod hyperbolic {
//             pub fn sinh(x: f32) -> f32 {
//                 (x.exp() - (-x).exp()) / 2f32
//             }
//             pub fn cosh(x: f32) -> f32 {
//                 (x.exp() + (-x).exp()) / 2f32
//             }
//         }
//     }
// }

mod math;

fn main() {
    use math::arithmetic::{add, mul};
    use math::trigonometry::hyperbolic::{cosh, sinh};
    use math::trigonometry::ordinary::{cos, sin};
}
