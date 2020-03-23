class MyArray < Array
    def [](*index)
        if index.length == 1 && 
            (index[0].class == Range || index[0].class == Integer)
            super(index[0])
        else
            index.collect { |i| super(i) }
        end
    end
end

a = MyArray.new(('a'..'z').to_a)
p a[1]
p a[0..3]
p a[0...3]
p a[0,24,25]