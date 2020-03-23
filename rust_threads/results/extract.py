import sys

for line in open(sys.argv[1]):
    fields = line.strip().split(',')

    n = fields[0].replace("n=", "")
    thread_id = fields[1].replace("#threads=", "")
    ratio = fields[4].replace("ratio=", "")

    print(f"{n} {thread_id} {ratio}")