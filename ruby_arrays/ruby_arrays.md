---
title: Arrays: linear containers in Ruby
published: true
description: Ruby arrays
tags: #ruby #tutorial #beginners #functional
cover_image: https://thepracticaldev.s3.amazonaws.com/i/g5tzhbkfxzq74kxb0vt7.jpg
---


In this article, I'll focus on Ruby. I'll use the version 2.5.1:

```command
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux-gnu]
```


# Basic Ruby arrays

Like my previous article on Python here [Python lists](https://dev.to/dandyvica/lists-arrays-vectors-linear-containers-in-python-ruby-and-rust-17mn), I'll focus on some more advanced array features rather than basic ones.

```ruby
digits = [0,1,2,3,4,5,6,7,8,9] 
a = ["one", "two", "three", "four"]
```
Creating an array in Ruby is as easy as in Python:

```ruby
digits = [0,1,2,3,4,5,6,7,8,9] 
a = ["one", "two", "three", "four"]

# empty araay
empty = []
empty = Array.new()
empty = Array.new
```

You can mix types:

```ruby
mixed_array = ["one", 2, "three", 4]
```

When dealing with strings, you can use the *%w()* construct to build an array from a litteral string:

```ruby
lipsum = %w(Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.)
```

or even create an array of arrays:

```ruby
binomial_coefficients = [
    [1],
    [1,1],
    [1,2,1],
    [1,3,3,1],
    [1,4,6,4,1],
    [1,5,10,10,5,1]
]
```

To initialize an array with the same element, just use * :

```ruby
['A'] * 5       # gives ['A', 'A', 'A', 'A', 'A']
# or
Array.new(5,'A')
```

The number of elements of an array is given by *length()* method:
```ruby
binomial_coefficients.length            # gives 6
lipsum.length                           # 19
```
You can also store objects, classes or functions in an array:

```ruby
# array of functions
trigo = [Math.method(:sin),Math.method(:cos),Math.method(:tan)]

# array of lambdas
powers = [
    ->(x) { x*x }, 
    ->(x) { x**3 },
    ->(x) { x**4 }
]

# array of classes
require 'set'
collections = [Array, Hash, Set]

# array of objects
empty_collections = [Array.new, Hash.new, Set.new]
```
## Accessing elements
Accessing array elements is business as usual, with some very useful refinements :

```ruby
first_binomial = binomial_coefficients[0]
last_binomial = binomial_coefficients[-1]
fifth_binomial = binomial_coefficients[-2]
binomial_coefficients[4].length # gives 5
```

Sub-arrays are possible using index slices:
```ruby
first3_binomials = binomial_coefficients[0...3]
first4_binomials = binomial_coefficients[0..3]
```

Note the difference between the open range `(...)` and the closed one `(..)`.

## Array operations
* adding an element
```ruby
digits.push(10)
```

* deleting an element by index
```ruby
digits.delete_at(10)
```
* concatenating arrays
```ruby
digits = [0,1,2,3,4] + [5,6] + [7,8,9]
```
* testing element membership
```ruby
# methods ending with a trailing ? return a boolean
if digits.include?(9) then
    puts("9 is a digit ! Such a surprise ;-)")
end
```
## Looping through an array
Use the for-in construct (also available for *until*, *while*, *until*)
```ruby
for d in digits do
    puts(d)
end
```

but a more functional oriented way is to use the *each* method:
```ruby
digits.each { |d| puts(d) }
```


To get the element index when looping, use the *each_with_index* method:

```ruby
digits.each_with_index { |d,i| 
    puts("#{d} is the #{i}-th digit")
}
```


# More advanced usage

## Some useful functions on arrays

```ruby
digits = [0,1,2,3,4,5,6,7,8,9]
digits.sum      # gives 45
digits.max      # gives 9
digits.min      # gives 0

# get any word being the longest
lipsum.max{ |a, b| a.length <=> b.length }           # gives 'consectetur'
```

The *zip()* built-in array method combines several arrays to create a resulting array, created by taking the i-th element of each array:

```ruby
a = [0,1,2,3]
b = [4,5,6,7]
a.zip(b) # gives [[0, 4], [1, 5], [2, 6], [3, 7]]
```

## No array comprehensions
In Ruby, there's no clean syntax as list comprehensions in Python. But those are very akin to higher order function as *map*. So you can achieve the same result with *map* or *collect* methods:

```ruby
# extract words ending with 't'
# compact() method is used to get rid of nil values
lipsum = %w(Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.)
end_with_t = lipsum.map { |w| w if w.end_with?('t') }.compact  # gives ['sit', 'incididunt', 'ut', 'et']

# convert to uppercase
lipsum.map { |w| w.upcase }
lipsum.map(&:upcase)

# get only words of length 5 (including commas)
lipsum.map { |w| w if w.length == 5 }.compact # gives ['Lorem', 'ipsum', 'dolor', 'amet,', 'elit,', 'magna']

# create new objects from an array of classes
require 'set'
[Array, Hash, Set].map{ |cls| cls.new }

# same as before when function called doesn't require an argument
[Array, Hash, Set].map(&:new)

# get pi/4 value from trigonometric functions array
trigo = [Math.method(:sin),Math.method(:cos),Math.method(:tan)]
trigo.map { |f| f.call(Math::PI/4) }
```

## Using the *to_a* method on an enumerable
Similar to the built-in *list()* function in Python, Ruby comes with the *to_a* method which creates an array from an enumerable (Ruby name for iterator):

```ruby
# this creates an array of a-z chars
a_to_z = ('a'..'z').to_a

# create digits and the first 100 even numbers
digits = (0..9).to_a
even = (0...100).step(2).to_a

# to_a() is idempotent, but this creates another reference not a new array
digits.to_a # gives back a copy of digits 
```
This obviously works for user defined iterators:

```ruby
class One
    include Enumerable
  
    def each
        yield "one"
        yield "un"
        yield "ein"
        yield "uno"
    end
end

# gives ['one', 'un', 'ein', 'uno']
One.new.to_a
```


## Inheriting the Array class
Nothing prevents you to subclass the *Array* class to create your own user-defined array. This example implements a way to access elements of an array by giving several indexes:

```ruby
# Based on the Array class, but accept sparse indexes
# Doesn't manage range of chars
class MyArray < Array
    def [](*index)
        if index.length == 1 && 
            (index[0].class == Range || index[0].class == Integer)
            super(index[0])
        else
            index.collect { |i| super(i) }
        end
    end
end

a = MyArray.new(('a'..'z').to_a)
a[1]              # "b"
a[0..3]           # ["a", "b", "c", "d"]
a[0...3]          # ["a", "b", "c"]
a[0,24,25]        # ["a", "y", "z"]
```

# Acting on arrays
Using functional programming built-in functions, you can extract values from an array, or get another array from the source one.

### *map()* or *collect()*

Using the *map()* built-in function, it's possible to get an image of a mapping on the array. If you consider an array as a mathematical set of elements, *map()* gives the image set through the considered function.

```ruby
a_to_z = ('a'..'z').to_a
A_to_Z = a_to_z.map{ |c| c.upcase }

# map() uses a block which can be more advanced
# greek letters: ["α", "β", "γ", "δ", "ε", "ζ", "η", "θ", "ι", "κ", "λ", "μ", "ν", "ξ", "ο", "π", "ρ", "ς", "σ", "τ", "υ", "φ", "χ", "ψ", "ω", "ϊ", "ϋ", "ό", "ύ", "ώ"]
greek = ('α'..'ω').to_a
greek.map{ |g| 
    case g
        when "α"
            "A"
        when "β"
            "B"
        when "γ"
            "C"
        # and so on
        else
            "X"
    end
}
```

Of course, the map function to pass as the first argument could be any function, and any lambda having one argument is possible:

```ruby
digits = (0..9).to_a
digits.map( &->(x) { x*10 } )        # gives tenths

# refer to binomial_coefficients above
binomial_coefficients.map(&:sum)  # gives [1, 2, 4, 8, 16, 32]
```

or even a user-defined function:

```ruby
# contrived example
def square(x)
    x**2
end

# calculate first 9 perfect squares
digits = (0..9).to_a
digits.map(&method(:square))      # gives [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

* *select()*

This built-in function is used to sieve elements from an array, using some criteria. Elements kept are those where the function given as the first argument to *select()* returns *true*.

```ruby
# extract even numbers
digits = (0..9).to_a
digits.select { |n| n%2 == 0 }        # gives [0, 2, 4, 6, 8]

# extract words less than 4 chars
lipsum = %w(Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.)
lipsum.select { |w| w.length < 4 }   # gives ['sit', 'sed', 'do', 'ut', 'et']
```

* *inject()*

Refer to my previous article on Python's *reduce()* to get some details on the *inject()* method.

Examples:

```ruby
digits = (0..9).to_a

# sum of first 10 digits
digits.inject { |x,y| x+y }   # gives 45

# this uses an initializer
digits.inject(10) { |x,y| x+y } # gives 55 = 45+10

# a more sophisticated example: this uses the nested multiplication to compute the value of a polynomial, given its coefficients and the unknown value z. BTW, an example of how to extend the Array class ;-)
class Array
    def nested(z)
        self.inject { |x,y| z*x+y }
    end
end
[1,5,10,10,5,1].nested(1)       # gives 32

# easy computation of the nested square root which converges to the golden ratio
([1]*100).inject { |x,y| Math::sqrt(x+y) }   # gives 1.618033988749895

# same for the canonical continued fraction. Note to to_f method to convert to float when dividing, otherwise no division is applied
([1]*100).inject { |x,y| y+1/x.to_f }

# this sums all columns of a matrix
matrix = (0..3).to_a.map { |i| [i]*4 }

matrix.each_with_index.inject([0]*4) { |x, (y,i)|
    x.map!.with_index { |e,i| e+y[i] }
}

```

Last part will be devoted to Rust vectors.


> Photo by Susan Yin on Unsplash