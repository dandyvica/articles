import sequtils
import sugar
import bigints

const 
    n =  15

proc product[T](data: seq[T]) {.thread.} =
    echo "data=" , data
    echo foldl(data, a * b)

proc sum[T](data: seq[T]) {.thread.} =
    echo "data=" , data
    echo foldl(data, a + b)    

# build a sequence of first n big integers
var firstN1 = toSeq(1..n)
var firstN2 = toSeq(1..n).map(i => initBigInt(i))

sum(firstN1)
sum(firstN2)

product(firstN1)
product(firstN2)


