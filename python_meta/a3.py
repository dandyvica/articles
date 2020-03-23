class A:
    """ doc for class A """
    def __new__(cls):
        print(f"creating class {cls}")
        setattr(cls, 'foobar', 123)
        return cls

a = A()
print(dir(a))