""" Save all URLs the proxy finds """
import re
import sys

text = sys.argv[1]

# define a new list for holding all compiled regexes
urls = []

# read the configuration file having all regexes
for re_url in open('urls.txt'):
    urls.append(re.compile(re_url.strip()))

print(f"{len(urls)} urls read")
print(urls)

if any(re.search(url, text) for url in urls):
    print(f"found match for {text}")
else:
    print("no match")
