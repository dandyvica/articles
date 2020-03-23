from functools import reduce

def nested(z: int, coeff: list) -> int:
    res = reduce(lambda x,y: z*x+y, coeff)
    return res

print(nested(20, [1,5,10,10,5,1]), (21)**5)



