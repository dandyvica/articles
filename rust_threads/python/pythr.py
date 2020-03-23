# try to simulate mutli-threaded product
import sys
import math
import time
import threading
import queue
from operator import mul
from functools import reduce

# create a function called "chunks" with two arguments, l and n:
def chunks(l: list, n: int) -> list:
    # for item i in a range that is a length of l,
    for i in range(0, len(l), n):
        # create an index range for l of n items:
        yield l[i:i+n]

# function to get the product of a list
def product(l: list) -> int:
    return reduce(mul, l, 1)

# thread worker
def worker(sub_list: list):
    # add partial product in the queue
    partial_products.put(product(sub_list))
    #print(f"sub_list {sub_list} product = {product(sub_list)}")
    return

# get n and nb_threads as arguments
n = int(sys.argv[1])
nb_threads = int(sys.argv[2])

# get fact
#print(f"{n}! = {math.factorial(n)}")

# n-first integers == 1 to n inclusive
n_first_integers = list(range(1,n+1))

# create a list of chunks
chunk_size = int(n / nb_threads)
chunks = list(chunks(n_first_integers, chunk_size))
#print(chunks)

# prepare slicing

# mono_threaded product
start_time = time.time()
fact_mono = product(n_first_integers)
elapsed_time_mono = time.time() - start_time
print(f"mono_threaded time for {n}! = {elapsed_time_mono}")

# multi_threaded product

# list of started threads
start_time = time.time()
threads = []

# queue to communicate between children threads and main thread: each thread will push its partial product
partial_products = queue.Queue()

# start threads and call the worker func
for chunk in chunks:
    t = threading.Thread(target=worker, args=(chunk,))
    threads.append(t)
    t.start()

# wait for threads to finish
for t in threads:
    t.join()

# compute product of partial products
fact_multi = 1
while not partial_products.empty():
    partial = partial_products.get()
    fact_multi *= partial

elapsed_time_multi = time.time() - start_time

# for partial in iter(partial_products.get_nowait, None):
print(f"multi_threaded time for {n}! = {elapsed_time_multi}")
