import exception.ProductNotFound;
import exception.QuantityException;
import model.Inventory;
import model.Product;

import java.util.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/*
  The Application class manages an inventory system, simulating the sales process
  and periodically checking the inventory to ensure its consistency. It allows the user
  to specify the number of threads and the number of operations each thread performs.
 */
public class App {
    private Inventory inventory;
    public App(){}
    private void checkInventoryThread() {
        inventory.checkInventory();
    }
    private void generateInventoryProducts(){
        inventory = new Inventory();
        List<String> products = Arrays.asList("Chair", "Table", "Mirror", "Brush", "Wardrobe");
        List<Integer> prices = Arrays.asList(200, 400, 100, 50, 800);
        List<Integer> quantities = Arrays.asList(2, 1000000, 1000000, 1000000, 1000000);
        List<Product> productList = new ArrayList<>();
        for(int i=0; i< products.size(); i++){
            Product product = new Product(products.get(i), prices.get(i), quantities.get(i));
            productList.add(product);
        }
        inventory.setProducts(productList);
    }

    public void start(){
        this.generateInventoryProducts();
        Random random = new Random();
        List<String> products = inventory.getProductNames();

        Scanner scanner = new Scanner(System.in);
        System.out.println("Please input the number of threads:");
        int numberOfThreads = scanner.nextInt();
        System.out.println("Please input how many operations for each thread:");
        int numberOfOperations = scanner.nextInt();

        ExecutorService executorService = Executors.newFixedThreadPool(numberOfThreads);
        ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(1);
        scheduledExecutorService.scheduleAtFixedRate(this::checkInventoryThread, 0 , 1, TimeUnit.SECONDS);

        //each thread will do a sale operation. Each sale operation will sell 2 different products with random quantities between 1 and 3
        for(int i = 0; i <numberOfOperations; i++){
            for(int j=0; j< numberOfThreads;j++){
                executorService.submit(()->{
                    Map<String, Integer> sales = new HashMap<>();
                    int firstProduct = random.nextInt(products.size());
                    int secondProduct = random.nextInt(products.size());
                    while(firstProduct == secondProduct){
                        secondProduct = random.nextInt(products.size());
                    }
                    sales.put(products.get(firstProduct), random.nextInt(3)+1);
                    sales.put(products.get(secondProduct), random.nextInt(3)+1);
                    try{
                        inventory.sellProducts(sales);
                    }catch (ProductNotFound | QuantityException e){
                        throw new RuntimeException(e);
                    }
                });
            }
        }
        executorService.shutdown();
        scheduledExecutorService.shutdown();

        try{
            // wait until all tasks are finished
            if (!executorService.awaitTermination(60, java.util.concurrent.TimeUnit.SECONDS)) {
                executorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            executorService.shutdownNow();
        }

        inventory.checkInventory();
        System.out.println(inventory.toString());
        System.out.println("Done!");
        scanner.close();
    }
}
