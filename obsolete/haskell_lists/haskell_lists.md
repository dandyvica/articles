---
title: Haskell lists
published: false
description: Python lists
tags: #haskell #tutorial #beginners #functional
cover_image: https://thepracticaldev.s3.amazonaws.com/i/g5tzhbkfxzq74kxb0vt7.jpg
---

# Haskell lists



```command
GHCi, version 8.0.2: http://www.haskell.org/ghc/  :? for help
Prelude> 
>>> 
```

# Basic lists
I'll give some examples for using lists in Python but I'll just skim over some of the useful features. I'll focus on other interesting facets of lists, rather than basic ones. For a list of detailed operations and functions on lists, refer to the official Python documentation.

Creating a list in Haskell is easy peasy:

```haskell
digits = [0,1,2,3,4,5,6,7,8,9] 
one2four = ["one", "two", "three", "four"]

# an empty list
empty = []
```

You can't mix types:

```haskell
mixed_list = ["one", 2, "three", 4]
```

You can of course even create a list of lists:

```haskell
binomial_coefficients = [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1],[1,5,10,10,5,1]]
```

To initialize a list with the same element, use the *replicate* function :

```haskell
['A'] * 5       # gives ['A', 'A', 'A', 'A', 'A']
```

The number of elements of a list is given by the built-in function *length()*:
```haskell
length binomial_coefficients          # gives 6
```
You can also store objects, classes or functions in a list:

```haskell
# list of functions
trigo = [sin, cos, tan]

# list of lambdas
powers = [
    lambda x: x*x,
    lambda x: x*x*x,
    lambda x: x**4
]

# list of classes
collections = [list, dict, set]

# list of objects
empty_collections = [list(), dict(), set()]
```


## Accessing elements
Accessing list elements is not business as usual, using the somewhat weird *!!* index operator:

```haskell
first_binomial = binomial_coefficients :: 0
last_binomial = binomial_coefficients[-1]
fifth_binomial = binomial_coefficients[-2]
len(binomial_coefficients[4]) # gives 5
```

Sublists are possible using index slices:
```haskell
first3_binomials = binomial_coefficients[0:3]
```

## List operations
* adding an element
```haskell
digits.append(10)
```

* deleting an element by index
```haskell
del digits[10]
```
* concatenating lists
```haskell
digits = [0,1,2,3,4] + [5,6] + [7,8,9]
```
* testing element membership
```haskell
if 9 in digits:
    print("9 is a digit! Such a surprise ;-)")
```

## Looping through a list
Use the for-in construct:
```haskell
for d in digits:
    print(d)
```

To get the element index when looping, use the built-in *enumerate()* function:

```haskell
for i,d in enumerate(digits):
    print(f"{d} is the {i}-th digit")
```


# More advanced usage

## Some useful functions on lists

```haskell
digits = [0,1,2,3,4,5,6,7,8,9]
sum(digits)         # gives 45
max(digits)         # gives 9
min(digits)         # gives 0

# min & max could also be used with other types, with the key keyword argument
lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split()

# get any word being the longest
max(lipsum, key=len)           # gives 'consectetur'
```

The *zip()* built-in function combines several lists to create an iterable of tuples, created by taking the i-th element of each list:

```haskell
a = [0,1,2,3]
b = [0,1,2,3]

# display tuples
for i in zip(a,b):
    print(i)
```


## List comprehensions
List comprehensions are an effecitve way to create new lists or extract elements from a list:

```haskell
# extract words ending with 't'
lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split()
end_with_t = [w for w in lipsum if w.endswith('t')]  # gives ['sit', 'incididunt', 'ut', 'et']

# convert to uppercase
[w.upper() for w in lipsum]

# get only words of length 5 (including commas)
[w for w in lipsum if len(w) == 5]    # gives ['Lorem', 'ipsum', 'dolor', 'amet,', 'elit,', 'magna']

# create new objects from a list of classes
[c() for c in [list, dict, set]]

# get pi/4 value from trigonometric functions list
import math
trigo = [math.sin, math.cos, math.tan]
[f(math.pi/4) for f in trigo]
```

You can also use nested iteration with comprehensions:

```haskell
a = [0,1,2,3]
b = [0,1,2,3]
[[i,j] for i in a for j in b] # gives [[0, 0], [0, 1], [0, 2], [0, 3], [1, 0], [1, 1], [1, 2], [1, 3], [2, 0], [2, 1], [2, 2], [2, 3], [3, 0], [3, 1], [3, 2], [3, 3]]
```

but beware this is a cartesian product:

```haskell
a = [0,1,2,3]
b = [0,1,2,3]

# this doesn't give the summation of both lists
[i+j for i in a for j in b] # gives [0, 1, 2, 3, 1, 2, 3, 4, 2, 3, 4, 5, 3, 4, 5, 6]
```

Use this to get the summation of elements position-wise:

```haskell
a = [0,1,2,3]
b = [0,1,2,3]
[x+y for i,x in enumerate(a) for j,y in enumerate(b) if i == j] # gives [0, 2, 4, 6]

# gives the same result
[i+j for (i,j) in list(zip(a,b))]
```

## Using the built-in *list()* function
The built-in *list()* function is very powerful to create lists in a  concise and efficient way. As soon as the item you pass into *list()* is iterable, it uses its iterator to create a list:

```haskell
# this creates a list of a-z chars
a_to_z = list("abcdefghijklmnopqrstuvwxyz")

# create digits and the first 100 even numbers
digits = list(range(10))
even = list(range(0,100,2))

# list() is idempotent, but this creates another list, not another reference
list(digits)  # gives back a copy of digits 
```
This obviously works for user defined iterators:

```haskell
class One:
    def __iter__(self):
        yield "one"
        yield "un"
        yield "ein"
        yield "uno"

# gives ['one', 'un', 'ein', 'uno']
print(list(One()))
```


## Inheriting the list class
Nothing prevents you to subclass the *list* class to create your own user-defined lists. This example implements a way to access elements of a list by giving several indexes:

```haskell
""" Based on list, but accept sparse indexes """
class MyList(list):
    def __getitem__(self, *args):
        # if only one index, just return the element as usual
        if type(args[0]) == int or type(args[0]) == slice:
            return list.__getitem__(self, args[0])
        # otherwise build a list with asked indexes
        else:       
            return [x for i,x in enumerate(self) if i in args[0]]

my_list = MyList(list("abcdefghijklmnopqrstuvwxyz"))
print(my_list[0])           # gives 'a'
print(my_list[0:2])         # gives ['a', 'b']
print(my_list[0,24,25])     # gives ['a', 'y', 'z']
```



## Acting on lists
Using functional programming built-in functions, you can extract values from a list, or get another list from the source one.

### *map()*

Using the *map()* built-in function, it's possible to get an image of a mapping on the list. If you consider a list as a mathematical set of elements, *map()* gives the image set through the considered function.

```haskell
a_to_z = list("abcdefghijklmnopqrstuvwxyz")
A_to_Z = list(map(str.upper, a_to_z))
```

*map()* itself gives back a map object which is iterable, that's why to get a list, the *list()* function is needed.

Of course, the map function to pass as the first argument could be any function, and any lambda having one argument is possible:

```haskell
digits = [0,1,2,3,4,5,6,7,8,9]
list(map(lambda x: x*10, digits))        # gives tenths

# refer to binomial_coefficients above
list(map(sum, binomial_coefficients))   # gives [1, 2, 4, 8, 16, 32]
```

or even a user-defined function:

```haskell
# contrived example
def square(x):
    return x*x

# calculate first 9 perfect squares
digits = [0,1,2,3,4,5,6,7,8,9]
print(list(map(square, digits)))
```

* *filter()*

As its name suggests, this built-in function is used to sieve elements from a list, using some criteria. Elements kept are those where the function given as the first argument to *filter()* returns *True*.

```haskell
# extract even numbers
digits = [0,1,2,3,4,5,6,7,8,9]
list(filter(lambda x: x%2 == 0, digits))        # gives [0, 2, 4, 6, 8]

# extract words less than 4 chars
lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split()
print(list(filter(lambda w: len(w) < 4, lipsum)))   # gives ['sit', 'sed', 'do', 'ut', 'et']
```

* *reduce()*

Starting from Python3, the *reduce()* function has been moved to the *functools* module. It basically reduces an iterable to a single value, by cumulating calls to a function.

So *reduce(function, iterable, initializer)* could be defined as:

```tex
let f a Python function, a=(a0,a1,...., an) an iterable giving (n+1) values, then:

reduce(f,a,init) = f(.....f(f(f(init,a0), a1), a2)....., an)
```

Examples:

```haskell
from functools import reduce

digits = list(range(10))

# sum of first 10 digits
reduce(lambda x,y: x+y, digits)   # gives 45

# this uses an initializer
reduce(lambda x,y: x+y, digits, 10) # gives 55 = 45+10

# a more sophisticated example: this uses the nested multiplication to compute the value of a polynomial, given its coefficients and the unknown value z (uses type hinting btw)
def nested(z: int, coeff: list) -> int:
    res = reduce(lambda x,y: z*x+y, coeff)
    return res

# easy computation of the nested square root which converges to the golden ratio
import math
reduce(lambda x,y: math.sqrt(x+y), [1]*100)   # gives 1.618033988749895

# same for the canonical continued fraction
reduce(lambda x,y: y+1/x, [1]*100)

# this sums all columns of a matrix
matrix = [[i]*4 for i in range(4)]
reduce(lambda a,b: [x+y for i,x in enumerate(a) for j,y in enumerate(b) if i == j], matrix) # gives [6, 6, 6, 6]
```

In the next post, I'll explain Ruby arrays.

> Photo by Susan Yin on Unsplash