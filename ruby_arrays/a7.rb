matrix = (0..3).to_a.map { |i| [i]*4 }

p matrix.each_with_index.inject([]) { |x, (y,i)|
    x.map!.with_index { |e,i| e+y[i] }
}