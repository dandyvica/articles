pub fn sinh(x: f32) -> f32 {
    (x.exp() - (-x).exp()) / 2f32
}
pub fn cosh(x: f32) -> f32 {
    (x.exp() + (-x).exp()) / 2f32
}
