# type inference for sequence. Note these are immutable
let digits = @[0,1,2,3,4,5,6,7,8,9]
let one_to_four = @["one", "two", "three", "four"]

#let mixed = @["one", 1]

# for an empty sequence, you must hint the element's type
let empty_seq = newSeq[int]()

# create a sequence of sequences
let binomial_coefficients = @[
    @[1],
    @[1,1],
    @[1,2,1],
    @[1,3,3,1],
    @[1,4,6,4,1],
    @[1,5,10,10,5,1]
]

# sequence with the same element
import sequtils
let five_a = repeat('A',5)

# number of elements
assert binomial_coefficients.len == 6

# list of functions
# import math
# type math_trigo = (proc(x: float32) : float32)
# let trigo = @[sin(float32)]

let 
    first_binomial = binomial_coefficients[0]
    last_binomial = binomial_coefficients[^1]
    fifth_binomial = binomial_coefficients[^2]

assert binomial_coefficients[4].len == 5

let first3_binomials = binomial_coefficients[0..<3]

for d in digits:
    echo d