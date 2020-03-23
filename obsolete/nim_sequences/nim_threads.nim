# compile with: nim c -r --boundChecks:off --threads:on nim_threads.nim
import sequtils
import sugar
import bigints
import locks
import os
import strutils

var
    #threads: array[0..nbThreads, Thread[seq[BigInt]]]
    L: Lock

#
proc partialProduct[T](data: seq[T]) {.thread.} =
    # acquire(L)
    # echo "data=", data
    # let partial = foldl(data, a * b)
    # echo partial
    # release(L)
    acquire(L)
    let partial = foldl(data, a * b)
    echo partial
    release(L)

proc parallelTask[T](data: seq[T], nbThreads: int) =
    # declare a sequence for holding threads
    var threads: seq[Thread[seq[BigInt]]]
    var th: Thread[seq[BigInt]]

    # number of elements in the sequence
    let n = data.len()

    # optimal chunk size
    let chunkSize = int((n + nbThreads - 1) / nbThreads)

    # slice sequence indexes into almost equal chunks and start a new thread to calculate the partial product
    for i in countup(0, n, chunkSize):
        # data[i..<j] is a slice of data
        let j = min(i+chunk_size, n)
        echo "i=",i," j=", j
        echo " slice=", data[i..<j]

        echo "creating thread#"
        createThread(th, partialProduct, data[i..<j])
        echo "adding th"
        threads.add(th)

    # wait for all threads to terminate
    joinThreads(threads)

# # multi-threaded factorial
# for i in 0..high(threads):
#     createThread(threads[i], partialProduct, firstN[3..10])
# joinThreads(threads)

initLock(L)

#----------------------------------------------------------------------------
# get arguments
#----------------------------------------------------------------------------
let n = parseInt(paramStr(1))
let nbThreads = parseInt(paramStr(2))

# declare a sequence for holding threads
var threads = newSeq[Thread[seq[BigInt]]](nbThreads)

# # build a sequence of first n big integers
var firstN = toSeq(1..n).map(i => initBigInt(i))

# # get the product using mono_threaded
# let factorialMono = firstN.foldl(a * b)
# echo factorialMono

# # multi-threaded factorial
# for i in 0..high(threads):
#     createThread(threads[i], partialProduct, firstN[3..10])
# joinThreads(threads)

parallelTask(firstN, nbThreads)