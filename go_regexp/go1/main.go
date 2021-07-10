package main

import (
	"bufio"
	"fmt"
	"log"
	"os"

	"regexp"
	"strconv"
)

type Log struct {
	ip          string // client ip address
	date        string // timestamp of connexion
	method      string // HTTP method
	path        string // requested URL
	httpVersion string // HTTP/1.1 generally here
	httpStatus  int    // HTTP status code
	size        int    // payload size
	userAgent   string // user agent string
}

const (
	all = `^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}) - - \[(.*?)\] "(.+?) (.+?) (.+?)" (\d+) ([\-\d]+) "(.*?)" "(.*?)" "\-"$`
)

var allRE = regexp.MustCompile(all)

func main() {
	// open file for reading
	file, err := os.Open("../access_simple.log")
	if err != nil {
		log.Fatal(err)
	}

	// close file when process ends
	defer file.Close()

	// define a new scanner and read the file line by line
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		//fmt.Printf("line=<%s>\n", line)

		data := getAllLogData(line)
		fmt.Printf("%+v\n", data)
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}

// get only the phone number and the timestamp
func getAllLogData(line string) Log {
	var logData Log

	// get capture groups
	submatch := allRE.FindStringSubmatch(line)
	//fmt.Printf("submatch=%+v\n", submatch)

	// fill structure with data we found
	logData.ip = submatch[1]
	logData.date = submatch[2]
	logData.method = submatch[3]
	logData.path = submatch[4]
	logData.httpVersion = submatch[5]
	logData.httpStatus, _ = strconv.Atoi(submatch[6])
	logData.size, _ = strconv.Atoi(submatch[7])
	logData.userAgent = submatch[9]

	// for i, s := range submatch {
	// 	fmt.Printf("%d, s=<%+v>\n", i+1, s)
	// }

	return logData
}
