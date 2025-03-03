package Algorithms;

import Model.Polynomial;
import Model.Task;

import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class ParallelClassic { //parallelized polynomial multiplication

    // each coefficient in the resulting polynomial is computed as a sum of products of coefficients from the two input polynomials
    private static final int NO_THREADS = 4;

    public static Polynomial multiply(Polynomial p1, Polynomial p2) throws InterruptedException {

        //initialize result polynomial with a list of zero coefficients
        int sizeOfResultCoefficientList = p1.getDegree() + p2.getDegree() + 1;
        List<Integer> coefficients = IntStream.range(0, sizeOfResultCoefficientList).mapToObj(i -> 0).collect(Collectors.toList());
        Polynomial result = new Polynomial(coefficients);

        //create threadpool
        ThreadPoolExecutor executor = (ThreadPoolExecutor) Executors.newFixedThreadPool(NO_THREADS);

        //each thread calculates a specific range of coeficients in parallel
        int step = sizeOfResultCoefficientList / NO_THREADS;
        if(step == 0){
            step = 1;
        }
        int end;
        for(int i = 0; i < sizeOfResultCoefficientList; i += step){
            end = i + step;
            Task task = new Task(i, end, p1, p2, result);
            executor.execute(task);
        }

        executor.shutdown();
        executor.awaitTermination(50, TimeUnit.SECONDS);

        return result;
    }

}