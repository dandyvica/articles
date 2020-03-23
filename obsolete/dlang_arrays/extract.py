# extract Rust code for Markdown article
display = False

print("void main() {")

import sys

for l in open(sys.argv[1]):
    line = l.strip()

    if line == '```d':
        display = True
        continue
    elif line == '```':
        display = False    
    
    if display == True:
        print(line)


print("}")