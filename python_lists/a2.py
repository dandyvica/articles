def square(x):
    return x*x

digits = [0,1,2,3,4,5,6,7,8,9]
print(list(map(square, digits)))

lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.".split()
print(list(filter(lambda w: len(w) < 4, lipsum)))