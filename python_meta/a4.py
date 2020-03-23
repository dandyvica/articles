class MyMetaClass(type):
    """ a metaclass derives from the 'type' type """

    def __new__(cls, name, bases, dict):
        """ __new()__ is the class constructor """
        print(f"cls={cls}, name={name}, bases={bases}, dict={dict}")
        return super().__new__(cls, name, bases, dict)

class MyClass(metaclass=MyMetaClass):
    pass

a = MyClass()
print(type(a))
