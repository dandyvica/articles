This time, I wanted to tackle the regular expression package in Go. In one of my recent projects, I had to use this library. But I have to confess it's not straightforward at first sight. I hope this article will unravel this feature.

To use the library (https://golang.org/pkg/regexp/), just add:

```go
import (
    ...
    "regexp"
    ...
)
```

to your code.

Following is a collection of tips for solving a specific problem. Throughout the following examples, I used the *assert* Go package to make it easier to understand.

## Compiling the regular expression
Before anything, you need to compile your regular expression before using any package function. You can use **Compile()** or **MustCompile()**. The difference between them is that the latter panics whenever an error is found compiling the regex but the former doesn't. If your code doesn't involve a regex provided at runtime, it's safer to use *MustCompile()* as you know immedialty whether your regex syntax is correct.

Note that the *Posix()* versions require a Posix regex rather than a *Perl-like* regular expression.

## Is my string matching the regexp ?
To just check whether a string is matching your regex, you can use two different functions:

```go
// don't worry, fake phone number
phone := "202-555-0147"
phoneRE := `\d{3}\-\d{3}\-\d{4}`

// returns: true <nil>
matched, err := regexp.MatchString(phoneRE, phone)
assert.True(matched)
assert.Nil(err)

// or compile and test
re := regexp.MustCompile(phoneRE)
assert.True(re.MatchString(phone))

// but this returns true as well!
assert.True(re.MatchString("202-555-0147mkljhfQDHMFJ"))

// but not this
re = regexp.MustCompile(`\d{3}\-\d{3}\-\d{4}$`)
assert.False(re.MatchString("202-555-0147mkljhfQDHMFJ"))
```

Beware that the string `202-555-0147mkljhfQDHMFJ` is matched using the first regex. The explanation is given is the *Compile()* definition and by the term *leftmost*:

```text
When matching against text, the regexp returns a match that begins as early as possible in the input (leftmost), and among those it chooses the one that a backtracking search would have found first. This so-called leftmost-first matching is the same semantics that Perl, Python, and other implementations use, although this package implements it without the expense of backtracking. 
```

You can influence this behavior with the *Longest()* function.

It's wiser to use *MustCompile()* or *Compile()* if you have to reuse your regex to just compile it once.

## Using capture groups
*Capture groups* are called *Submatches* in the regexp package. You get access to capture groups using on *FindStringSubmatch()* function:

```go
// use capture groups
phoneRECaps := `(\d{3})\-(\d{3})\-(\d{4})$`
re = regexp.MustCompile(phoneRECaps)

// caps is a slice of strings, where caps[0] matches the whole match
// caps[1] == "202" etc
matches := re.FindStringSubmatch(phone)

// print out: there're 3 capture groups
assert.Equal(re.NumSubexp(), 3)
assert.Equal(matches[0], "202-555-0147")
assert.Equal(matches[1], "202")
assert.Equal(matches[2], "555")
assert.Equal(matches[3], "0147")
assert.ElementsMatch(matches, []string{"202-555-0147", "202", "555", "0147"})
```

## Using named capture groups
To fully benefit from the Python-like *named capture groups*, you can't have a direct access to the value of the submatch for a particular name. You only have an indirect and unwieldy access: first get all names, the get the corresponding index for that name and then fetch the capture group string:

```go
// use named capture groups
phoneRENamedCaps := `(?P<area>\d{3})\-(?P<exchange>\d{3})\-(?P<line>\d{4})$`
re = regexp.MustCompile(phoneRENamedCaps)

// print out: [ area exchange line], not that the first element is the empty string
names := re.SubexpNames()
assert.ElementsMatch(names, []string{"", "area", "exchange", "line"})

// // indirect access to names
matches = re.FindStringSubmatch(phone)
assert.Len(matches, 4)
capName := names[1]; nameIndex := re.SubexpIndex(capName); assert.Equal(matches[nameIndex], "202")
capName = names[2]; nameIndex = re.SubexpIndex(capName); assert.Equal(matches[nameIndex], "555")
capName = names[3]; nameIndex = re.SubexpIndex(capName); assert.Equal(matches[nameIndex], "0147")
```

## Splitting a string
It might be useful sometimes to split a string delimited with characters matching a regexp:

```go
csv := "a;b;c;;;;d;e;f;;;g"

split1 := regexp.MustCompile(";").Split(csv, -1)
split2 := regexp.MustCompile(";*").Split(csv, -1)

assert.Len(split1, 12)
assert.ElementsMatch(split1, []string{"a", "b", "c", "", "", "", "d", "e", "f", "", "", "g"})

assert.Len(split2, 7)
assert.ElementsMatch(split2, []string{"a", "b", "c", "d", "e", "f", "g"})
```

## Replacing strings
You can replace strings by providing a template made of references to a matched capture group. You can use *$1* (or *${1}*) to refer to the first submatch, *$2* for the second etc:

```go
csv = "a;b;c;;;;d;e;f;;;g"

split := regexp.MustCompile("(;+)")

// prints: "a;b;c;d;e;f;g"
assert.Equal(split.ReplaceAllString(csv, ";"), "a;b;c;d;e;f;g")

digits := "0123456789"
digitsRe := regexp.MustCompile(strings.Repeat(`(\d)`,10))
assert.Equal(digitsRe.ReplaceAllString(digits, "$10$9$8$7$6$5$4$3$2$1"), "9876543210")
```

You can use names instead:

```go
// using names rather than indexes
digitsRe = regexp.MustCompile(`(?P<zero>\d)(?P<one>\d)(?P<two>\d)(?P<three>\d)(?P<four>\d)(?P<five>\d)(?P<six>\d)(?P<seven>\d)(?P<eight>\d)(?P<nine>\d)`)
assert.Equal(
    digitsRe.ReplaceAllString(digits, "nine=${nine}, eight=${eight}, seven=${seven}, six=${six}, five=${five}, four=${four}, three=${three}, two=${two}, one=${one}, zero=${zero}"),
    "nine=9, eight=8, seven=7, six=6, five=5, four=4, three=3, two=2, one=1, zero=0",
)
```

Hope this helps !

> Photo by <a href="https://unsplash.com/@rocinante_11?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Mick Haupt</a> on <a href="https://unsplash.com/s/photos/numbers?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
  

