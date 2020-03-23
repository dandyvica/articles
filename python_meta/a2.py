# create a simple class A dynamically. A is an instance of type
A = type('A', (), {})
print(type(A))

# create an instance of A. a is of type A
a = A()
print(type(a))

# just create a string

# create a Person class with default values for its attributes
Person = type('Person', (), {
    'first_name': 'John',
    'last_name' : 'Doe',
    'get_name': lambda self: self.first_name + ' ' + self.last_name
})
person = Person()
print(person.get_name())