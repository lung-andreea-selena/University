import java.util.List;

public class Producer extends Thread{
    public Buffer buffer;
    public List<Integer> vector1, vector2;

    public Producer(Buffer buffer, List<Integer> vector1, List<Integer> vector2){
        super("Producer");// setting the thread's name
        this.buffer = buffer;
        this.vector1 = vector1;
        this.vector2 = vector2;
    }

    @Override
    public void run(){
        for(int i = 0; i < vector1.size(); i ++){
            try{
                Integer v1 = vector1.get(i);
                Integer v2 = vector2.get(i);
                System.out.println("Producer is sending " + v1 + " and " + v2);
                buffer.put(v1 * v2); //syncronization happening
            }catch (InterruptedException e){
                e.printStackTrace();
            }
        }
    }
}
