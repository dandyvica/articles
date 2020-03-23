n=$1
nb_threads=$2

echo $n $nb_threads

for i in {2..$nb_threads}
do 
    echo "calling fact $n $i"
    target/release/fact $n $i >>rust_results.txt
done