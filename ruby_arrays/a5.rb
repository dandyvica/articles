# contrived example
def square(x)
    x**2
end

# calculate first 9 perfect squares
digits = (0..10).to_a
p digits.map(&method(:square))