void main() {
// type inference with auto
auto digits = [0,1,2,3,4,5,6,7,8,9];
auto a = ["one", "two", "three", "four"];

// an empty array
auto empty = [];
auto binomialCoefficients = [
[1],
[1,1],
[1,2,1],
[1,3,3,1],
[1,4,6,4,1],
[1,5,10,10,5,1]
];
import std.range;
auto a5 = new int[](5);         // defines a new array of 5 elements
a5[] = 5;                       // sets all elements to 5

import std.algorithm.comparison : equal;
assert(a5.equal([5,5,5,5,5]));
assert(binomialCoefficients.length == 6);
// list of functions
import std.math;
import std.stdio;

// need to specify the type of array elements because trigo functions are overloaded
double function(double)[] trigo = [&sin, &cos, &tan];
auto aa = trigo[0](PI);
//writeln(aa);

// list of lambdas
auto powers = [
(int x) => x*x,
(int x) => x^3,
(int x) => x^4,
];

// list of objects
//empty_collections = [list(), dict(), set()]
// $ the number of elements
auto firstBinomial = binomialCoefficients[0];
auto lastBinomial = binomialCoefficients[$-2];
auto fifthBinomial = binomialCoefficients[$-3];

assert(binomialCoefficients[4].length == 5);
auto first3Binomials = binomialCoefficients[0..3];
digits ~= 10;
assert(digits.equal([0,1,2,3,4,5,6,7,8,9,10]));
import std.algorithm;
digits = digits.remove(10);     // remove returns the modified array
assert(digits.equal([0,1,2,3,4,5,6,7,8,9]));
digits = [0,1,2,3,4] ~ [5,6] ~ [7,8,9];
assert(digits.equal([0,1,2,3,4,5,6,7,8,9]));
import std.algorithm: canFind;

if (digits.canFind(9)) {
writeln("9 is a digit! Such a surprise ;-)");
}
foreach (d; digits) {
writeln(d);
}
foreach (i,d; digits.enumerate()) {
writefln("%s is the %s-th digit", d, i);
}
digits = [0,1,2,3,4,5,6,7,8,9];

assert(digits.sum() == 45);
assert(digits.maxElement() == 9);
assert(digits.minElement() == 0);


// min & max could also be used with other types, with the key keyword argument
auto lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split();

// a.length is the predicate which maxElement() uses
assert(lipsum.maxElement!"a.length", "consectetur");
// extract words ending with 't'
lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split();

auto endWitht = lipsum.filter!(w => w.endsWith('t'));
assert(endWitht.equal(["sit", "incididunt", "ut", "et"]));

// convert to uppercase. Need to add .array() to convert range to an array
import std.string;
auto uppercaseWords = lipsum.map!(w => w.toUpper()).array();
assert(uppercaseWords[0] == "LOREM");

// get only words of length 5 (including commas)
auto length5 = lipsum.filter!(a => a.length == 5).array();
writeln("-", length5);
assert(length5 == ["Lorem", "ipsum", "dolor", "amet,", "elit,", "magna"]);
// [w for w in lipsum if len(w) == 5]    # gives ['Lorem', 'ipsum', 'dolor', 'amet,', 'elit,', 'magna']

// create new objects from a list of classes
// [c() for c in [list, dict, set]]

/*
# get pi/4 value from trigonometric functions list
import math
trigo = [math.sin, math.cos, math.tan]
[f(math.pi/4) for f in trigo]*/
}
