class One
    include Enumerable
  
    def each
        yield "one"
        yield "un"
        yield "ein"
        yield "uno"
    end
end

