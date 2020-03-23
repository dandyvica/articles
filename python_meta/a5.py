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


