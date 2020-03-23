""" Based on list, but accept disjoined indexes """
class MyList(list):
    def __getitem__(self, *args):
        # if only one index, just return the element
        if type(args[0]) == int or type(args[0]) == slice:
            return list.__getitem__(self, args[0])
        # otherwise build a list with asked indexes
        else:       
            return [x for i,x in enumerate(self) if i in args[0]]

my_list = MyList(list("abcdefghijklmnopqrstuvwxyz"))
print(my_list[0])
print(my_list[0:2])
print(my_list[0,24,25])

