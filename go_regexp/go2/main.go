package main

import (
	"fmt"
	"regexp"
	"strings"
)

func main() {
	//------------------------------------------------------------------------------------------------
	// ## Is my string matching the regexp ?
	//------------------------------------------------------------------------------------------------
	
	// don't worry, fake phone number
	phone := "202-555-0147"
	phoneRE := `\d{3}\-\d{3}\-\d{4}`

	// returns: true <nil>
	matched, err := regexp.MatchString(phoneRE, phone)
	fmt.Println(matched, err)

	// or compile and test
	re := regexp.MustCompile(phoneRE)
	fmt.Println(re.MatchString(phone))

	// but this returns to as well!
	fmt.Println(re.MatchString("202-555-0147mkljhfQDHMFJ"))

	// but not this
	re = regexp.MustCompile(`\d{3}\-\d{3}\-\d{4}$`)
	fmt.Println(re.MatchString("202-555-0147mkljhfQDHMFJ"))


	//------------------------------------------------------------------------------------------------
	// ## Using capture groups
	//------------------------------------------------------------------------------------------------

	// use capture groups
	phoneRECaps := `(\d{3})\-(\d{3})\-(\d{4})$`
	re = regexp.MustCompile(phoneRECaps)

	// caps is a slice of strings, where caps[0] matches the whole match
	// caps[1] == "202" etc
	matches := re.FindStringSubmatch(phone)

	// print out: there're 3 capture groups
	fmt.Printf("there're %d capture groups\n", re.NumSubexp())
	// print out: [202-555-0147 202 555 0147]
	fmt.Printf("%v\n", matches)

	//------------------------------------------------------------------------------------------------
	// ## Using named capture groups
	//------------------------------------------------------------------------------------------------

	// use named capture groups
	phoneRENamedCaps := `(?P<area>\d{3})\-(?P<exchange>\d{3})\-(?P<line>\d{4})$`
	re = regexp.MustCompile(phoneRENamedCaps)

	// print out: [ area exchange line], not that the first element is the empty string
	names := re.SubexpNames()
	fmt.Println(names)

	// indirect access to names
	matches = re.FindStringSubmatch(phone)
	for i := 1; i <= re.NumSubexp(); i++ {
		capName := names[i]
		nameIndex := re.SubexpIndex(capName)

		fmt.Printf("capture group '%s' value is '%s'\n", capName, matches[nameIndex])
	}

	//------------------------------------------------------------------------------------------------
	// ## Splitting a string
	//------------------------------------------------------------------------------------------------
	csv := "a;b;c;;;;e;f;;;g"

	split1 := regexp.MustCompile(";").Split(csv, -1)
	split2 := regexp.MustCompile(";*").Split(csv, -1)

	// prints: 11 elements returned: [a b c    e f   g]
	fmt.Printf("%d elements returned: %v\n", len(split1), split1)

	// prints:  elements returned: [a b c e f g]
	fmt.Printf("%d elements returned: %v\n", len(split2), split2)

	//------------------------------------------------------------------------------------------------
	// ## Replacing a string
	//------------------------------------------------------------------------------------------------
	csv = "a;b;c;;;;e;f;;;g"

	split := regexp.MustCompile("(;+)")

	// prints: "a;b;c;e;f;g"
	fmt.Println(split.ReplaceAllString(csv, ";"))

	digits := "0123456789"
	digitsRe := regexp.MustCompile(strings.Repeat(`(\d)`,10))
	fmt.Println(digitsRe.ReplaceAllString(digits, "$10$9$8$7$6$5$4$3$2$1"))



}
