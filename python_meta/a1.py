# empty classes


class A:
    """ comment for class A """
    pass


class B:
    """ comment for class B """
    pass


class C:
    """ comment for class C """
    pass

class D:
    """ comment for class D """
    pass


class E:
    """ comment for class E """
    pass

# classes are objects: we can store them into a list
list_of_classes = [A,B,C,D,E]

# type of classes are 'type'
for cls in list_of_classes:
    print(type(cls))
    print(cls.__doc__)

# we can define a function whose parameter is a class
def class_name(cls: type) -> str:
    return cls.__name__

# treat classes like objects
list_of_str_classes = [class_name(cls) for cls in list_of_classes]

# we get ['A', 'B', 'C', 'D', 'E']
print(list_of_str_classes)
