phrase = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

# convert each character to its ASCII representation
converted_phrase = [ord(x) for x in phrase]

# now compute sdbm hash
sdbm = reduce()