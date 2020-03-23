---
title: Introduction to Python metaclasses 
published: true
tags: #python #tutorial
cover_image: https://thepracticaldev.s3.amazonaws.com/i/32c0j5rifgg1fns5ubp6.jpg
---

Python metaclasses are an important, although not always used, metaprogramming feature. It allows, among other things, to dynamically create classes. As you can have an object factory method creating objects, using metaclasses, you can define a class factory.

What is a metaclass ? Basically, it's just a class of a class. 

## Classes are objects

When a class is instantiated, an object is created:

```python
>>> a = [1,2,3,4,5]
>>> type(a)
<class 'list'>
>>> 
```

But when the __class__ statement is met by the Python interpreter, it also creates an object, of type _type_:

```python
>>> class A:
...     pass
... 
>>> type(A)
<class 'type'>
```

So objects created from a class _T_ are of type _T_, but classes themselves are also objects of class _type_.

Being objects, classes can be manipulated directly as any Python object:

```python
# dummy classes
class A:
    """ comment for class A """
    pass


class B:
    """ comment for class B """
    pass


class C:
    """ comment for class C """
    pass

# classes are objects: we can store them into a list
list_of_classes = [A,B,C]

# type of classes are 'type'
for cls in list_of_classes:
    print(type(cls))
    print(cls.__doc__)

# we can define a function whose parameter is a class
def class_name(cls: type) -> str:
    return cls.__name__

# treat classes like objects
list_of_str_classes = [class_name(cls) for cls in list_of_classes]

# we get ['A', 'B', 'C']
print(list_of_str_classes)
```

# Creating classes dynamically

As a class instance is created using their type, we can do the same, with a different syntax, to create classes on the fly.

You're probably used to creating class instances:

```python
>>> a = A()
>>> type(a)
<class '__main__.A'>
>>> b = list()
>>> type(b)
<class 'list'>
>>> 
```

To create a new class, we need to use the _type_ class with a peculiar syntax.

The simplest way to create a class is:

```python
# create a simple class A dynamically. A is an instance of 'type'
A = type('A', (), {})
print(type(A))

# create an instance of A. a is of type A
a = A()
print(type(a))
```

The third argument allows to provide attributes to the brand new class:

```python
# create a Person class with default values for its attributes
Person = type('Person', (), {
    'first_name': 'John',
    'last_name' : 'Doe',
    'get_name': lambda self: self.first_name + ' ' + self.last_name
})

# create a Person instance
person = Person()
print(person.get_name())
```

You can also use the second argument (which is a tuple) to make the new class inheriting from another class.

# Metaclasses

A metaclass is a way to customize the way a class is created. 
To create a metaclass, you need to subclass the _type_ type. To make a class an instance of a metaclass, you'll use a dedicated syntax with _metaclass=_ argument:

```python
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
```




# Metaclasses use cases
From the Python official documentation:

> The potential uses for metaclasses are boundless. Some ideas that have been explored include enum, logging, interface checking, automatic delegation, automatic property creation, proxies, frameworks, and automatic resource locking/synchronization.

The following example illustrates an automatic attribute creation, used to pretty print instance variables:

```python
import pprint

class PrettyPrinterWrapper(type):
    def __new__(cls, name, bases, dict):
        """ define a new handler attribute a pretty printer instance """
        dict['pp'] = pprint.PrettyPrinter(width=20)

        return super().__new__(cls, name, bases, dict)

class A(metaclass=PrettyPrinterWrapper):
    def __init__(self, my_list: list):
        self.list = my_list

    def __str__(self):
        return self.pp.pformat(self.list)

a = A(["one","two","three","four"])
print(a)
```

Hope this helps !

> Photo by Alina Grubnyak on Unsplash