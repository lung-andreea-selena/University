public class Consumer extends Thread{
    public Buffer buffer;
    public Integer sum = 0;

    public Integer sizeOfVector;

    public Consumer(Buffer buffer, Integer sizeOfVector){
        super("Consumer");
        this.buffer = buffer;
        this.sizeOfVector = sizeOfVector;
    }

    @Override
    public void run(){
        for(int i = 0; i< sizeOfVector; i++){
            try{
                int value = buffer.get();
                sum = sum + value;
                System.out.println("Consumer has the sum " + sum);
            }catch(InterruptedException e){
                e.printStackTrace();
            }
        }
        System.out.println("Final sum: " + sum);
    }
}
