package main

import (
	"regexp"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
)
  
  func TestRegexes(t *testing.T) {
	assert := assert.New(t)

	//------------------------------------------------------------------------------------------------
	// ## Is my string matching the regexp ?
	//------------------------------------------------------------------------------------------------
	
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

	// but this returns to as well!
	assert.True(re.MatchString("202-555-0147mkljhfQDHMFJ"))

	// but not this
	re = regexp.MustCompile(`\d{3}\-\d{3}\-\d{4}$`)
	assert.False(re.MatchString("202-555-0147mkljhfQDHMFJ"))

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
	assert.Equal(re.NumSubexp(), 3)
	assert.Equal(matches[0], "202-555-0147")
	assert.Equal(matches[1], "202")
	assert.Equal(matches[2], "555")
	assert.Equal(matches[3], "0147")
	assert.ElementsMatch(matches, []string{"202-555-0147", "202", "555", "0147"})

	//------------------------------------------------------------------------------------------------
	// ## Using named capture groups
	//------------------------------------------------------------------------------------------------

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

	//------------------------------------------------------------------------------------------------
	// ## Splitting a string
	//------------------------------------------------------------------------------------------------
	csv := "a;b;c;;;;d;e;f;;;g"

	split1 := regexp.MustCompile(";").Split(csv, -1)
	split2 := regexp.MustCompile(";*").Split(csv, -1)

	assert.Len(split1, 12)
	assert.ElementsMatch(split1, []string{"a", "b", "c", "", "", "", "d", "e", "f", "", "", "g"})

	assert.Len(split2, 7)
	assert.ElementsMatch(split2, []string{"a", "b", "c", "d", "e", "f", "g"})

	//------------------------------------------------------------------------------------------------
	// ## Replacing a string
	//------------------------------------------------------------------------------------------------
	csv = "a;b;c;;;;d;e;f;;;g"

	split := regexp.MustCompile("(;+)")

	// prints: "a;b;c;d;e;f;g"
	assert.Equal(split.ReplaceAllString(csv, ";"), "a;b;c;d;e;f;g")

	digits := "0123456789"
	digitsRe := regexp.MustCompile(strings.Repeat(`(\d)`,10))
	assert.Equal(digitsRe.ReplaceAllString(digits, "$10$9$8$7$6$5$4$3$2$1"), "9876543210")

	// using names rather than indexes
	digitsRe = regexp.MustCompile(`(?P<zero>\d)(?P<one>\d)(?P<two>\d)(?P<three>\d)(?P<four>\d)(?P<five>\d)(?P<six>\d)(?P<seven>\d)(?P<eight>\d)(?P<nine>\d)`)
	assert.Equal(
		digitsRe.ReplaceAllString(digits, "nine=${nine}, eight=${eight}, seven=${seven}, six=${six}, five=${five}, four=${four}, three=${three}, two=${two}, one=${one}, zero=${zero}"),
		"nine=9, eight=8, seven=7, six=6, five=5, four=4, three=3, two=2, one=1, zero=0",
	)

  }