# Example to extend the array class
class Array
    def nested(z)
        self.inject { |x,y| z*x+y }
    end
end

p [1,5,10,10,5,1].nested(1)