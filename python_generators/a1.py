def fibonacci1(fib_max: int) -> int:
    # initial values
    fib_n_2 = 0
    fib_n_1 = 1
    yield fib_n_2
    yield fib_n_1

    fib_n = fib_n_2 + fib_n_1
    while fib_n <= fib_max:
        yield fib_n
        fib_n_2 = fib_n_1
        fib_n_1 = fib_n
        fib_n = fib_n_2 + fib_n_1

# gives: [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987]
print(list(fibonacci1(1000)))



