/******************************************************************************
 *  Compilation:  javac HelloWorld.java
 *  Execution:    java HelloWorld
 *
 *  Prints "Hello, World". By tradition, this is everyone's first program.
 *
 *  % java HelloWorld
 *  Hello, World
 *
 *  These 17 lines of text are comments. They are not part of the program;
 *  they serve to remind us about its properties. The first two lines tell
 *  us what to type to compile and test the program. The next line describes
 *  the purpose of the program. The next few lines give a sample execution
 *  of the program and the resulting output. We will always include such 
 *  lines in our programs and encourage you to do the same.
 *
 ******************************************************************************/

import java.math.BigInteger;
import java.util.List;
import java.util.stream.IntStream;
import java.util.stream.Collectors;

public class Factorial {

    public static void main(String[] args) {
        // get n and nb_threads
        int n = Integer.parseInt(args[0]);
        int nb_threads = Integer.parseInt(args[1]);

        // populate a vector with n first integers
        var numbers = IntStream.rangeClosed(1, n).boxed().collect(Collectors.toList());

        // 
        System.out.println(numbers);

        //int sum = n_first_integers.stream().mapToInt(Integer::intValue).sum();
        //int fact_mono = numbers.stream().reduce(0, Integer::mul);
        BigInteger fact_mono = numbers.stream().reduce(BigInteger.valueOf(1), (a, b) -> a * b);
    }

}