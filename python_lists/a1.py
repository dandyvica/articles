class One:
    def __iter__(self):
        yield "one"
        yield "un"
        yield "ein"
        yield "uno"

print(list(One()))