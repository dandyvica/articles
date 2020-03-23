# extract Rust code for Markdown article
display = False

import sys

for l in open(sys.argv[1]):
    line = l.rstrip()

    if line == '```python':
        display = True
        continue
    elif line == '```':
        display = False    
    
    if display == True:
        print(line)
