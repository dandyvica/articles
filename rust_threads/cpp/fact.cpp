// parallel factorial computation
// g++ -Wall -O3 fact.cpp -o fact -lgmp -lgmpxx -std=c++14 -lpthread

#include <iostream>
#include <string>
#include <vector>
#include <numeric>
#include <chrono>
#include <algorithm>
#include <assert.h>
#include <thread> 
#include <mutex>

#include <gmpxx.h>

// to keep partial products 
std::vector<mpz_class> partial_products;

// synchronize access to partial_products
std::mutex pp_mutex;

// product of elements, whole vector
mpz_class product(const std::vector<mpz_class> &v) {
    mpz_class one(1);
    return  std::accumulate(std::begin(v), std::end(v), one, std::multiplies<>());
}

// product of elements, partial vector
mpz_class product(const std::vector<mpz_class> &v, size_t i, size_t j) {
    mpz_class one(1);
    return  std::accumulate(std::begin(v)+i, std::begin(v)+j, one, std::multiplies<>());
}

// called by each thread
void worker(const std::vector<mpz_class> &v, size_t i, size_t j) {
    pp_mutex.lock();
    partial_products.push_back(product(v,i,j));
    pp_mutex.unlock();
}

// implements parallel factorial
int main(int argc, char *argv[]) 
{
    // check args
    if (argc == 1) {
        std::cout << "fact [n] [nb_threads]" << std::endl;
        return 1;
    }

    // get n abd nb_threads from args
    unsigned int n = std::atoi(argv[1]);
    mpz_class n_mpz(n);

    unsigned int nb_threads = std::atoi(argv[2]);

    // fill in a vector with n-first integers
    std::vector<mpz_class> numbers(n);

    mpz_class one(1);
    std::iota(numbers.begin(), numbers.end(), one);
    
    //----------------------------------------------------------------------------------------------------
    // mono_threaded computation
    //----------------------------------------------------------------------------------------------------
    auto start = std::chrono::steady_clock::now();
    auto fact_mono = product(numbers);
    auto end = std::chrono::steady_clock::now();

    auto duration_mono = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();

    // std::cout << "Mono_threaded elapsed time in microseconds : "
    //      << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count()
    //      << " µs" << std::endl;

    //----------------------------------------------------------------------------------------------------
    // multi_threaded computation
    //----------------------------------------------------------------------------------------------------
    start = std::chrono::steady_clock::now();

    // first, calculate chunks
    auto chunk_size = (n + nb_threads - 1) / nb_threads;

    // to keep threads 
    std::vector<std::thread> threads;

    // slice vector indexes into almost equal chunks and start a new thread to calculate the partial product
    for (unsigned int i=0; i<n; i += chunk_size) {
        auto j = std::min(i+chunk_size, n);
        threads.push_back(std::thread(worker,numbers,i,j));
    }

    // wait for threads to finish
    for (auto& t: threads) {
        t.join();
    }

    // finally compute product of partial products (== fn!)
    auto fact_multi = product(partial_products);

    end = std::chrono::steady_clock::now();

    auto duration_multi = std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();

    // std::cout << "Multi_threaded elapsed time in microseconds : "
    //      << std::chrono::duration_cast<std::chrono::microseconds>(end - start).count()
    //      << " µs" << std::endl;

    // check test validity: check if products are equal
    assert(fact_mono == fact_multi);

    // print out results
    std::cout 
        << "n=" << n << " ,"
        << "#threads=" << nb_threads << " ,"
        << "mono_threaded=" << duration_mono << "µs ,"
        << nb_threads << "_threaded=" << duration_multi << "µs ,"
        << "ratio=" << (float)duration_multi/(float)duration_mono << 
        std::endl;
                
  
    
    return 0;
}