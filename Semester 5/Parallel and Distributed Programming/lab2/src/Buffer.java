import java.util.LinkedList;
import java.util.Queue;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.Condition;

public class Buffer {
    private final Queue<Integer> queue = new LinkedList<>(); //stores the computed products from the producer until the consumer consumes them
    private final Lock lock = new ReentrantLock();
    private final Condition ProducerReadyToSendProduct = lock.newCondition();
    private final Condition ConsumerReadyToReceiveProduct = lock.newCondition();
    boolean isBufferEmpty = true;

    public Buffer(){}

    //called by the consumer to retrieve and consume a product from the buffer when is not empty and wait if is empty
    public int get() throws InterruptedException{
        lock.lock();
        try{
            while(isBufferEmpty){
                System.out.println(Thread.currentThread().getName() + "-> waits buffer empty (consumer tried to retrieve from an empty buffer)\n");
                ConsumerReadyToReceiveProduct.await();
            }
            Integer value = queue.poll();
            if(value != null){
                isBufferEmpty = true;
                System.out.printf(Thread.currentThread().getName() + " removed " + value + " from queue\n");
                ProducerReadyToSendProduct.signal(); // signal the producer
            }
            return value;
        } finally{
            lock.unlock();
        }
    }

    //called by the producer and putting the product if the buffer is empty, if not, it waits
    public void put(int value) throws InterruptedException{
        lock.lock();
        try{
            while(!isBufferEmpty){
                System.out.println(Thread.currentThread().getName() + "-> waits, queue is full (producer tried to put product in a full buffer)\n");
                ProducerReadyToSendProduct.await();
            }
            queue.add(value);
            isBufferEmpty = false;
            System.out.println(Thread.currentThread().getName() + " added value " + value + " to the queue ");
            ConsumerReadyToReceiveProduct.signal(); //signal the consumer
        }finally {
            lock.unlock();
        }
    }
}
