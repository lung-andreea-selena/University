package model;

import exception.ProductNotFound;
import exception.QuantityException;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Inventory {
    List<Product> products;
    List<Bill> bills;
    double totalMoney;
    Lock lock=new ReentrantLock();
    public Inventory(){
        this.products = new ArrayList<>();
        this.bills= new ArrayList<>();
        this.totalMoney=0;
    }

    public void setProducts(List<Product> products){
        this.products = products;
    }
    public List<String> getProductNames(){
        return products.stream().map(Product::getName).toList();
    }

    public Product sellProduct(String productName, int quantity) throws QuantityException, ProductNotFound{
        Product product = products.stream().filter(p->p.getName().equals(productName)).findFirst().orElse(null);
        if(product==null){
            throw new ProductNotFound();
        }
        System.out.println(product + "was sold");
        product.decrementQuantity(quantity);
        return product;
    }

    public void sellProducts(Map<String,Integer> products) throws ProductNotFound,QuantityException{
        Bill newBill= new Bill();
        for(Map.Entry<String, Integer> entry : products.entrySet()){
            String productName = entry.getKey();
            int quantity = entry.getValue();
            Product product= sellProduct(productName,quantity);
            newBill.addProduct(product);
            newBill.addMoney(product.getPrice() * quantity);
        }
        lock.lock();
        try{
            this.bills.add(newBill);
            totalMoney += newBill.getTotalPrice();
        }finally{
            lock.unlock();
        }
    }

    public void checkInventory(){
        double totalMoneyAllBills = 0;
        lock.lock();
        try{
            for(Bill bill: bills){
                totalMoneyAllBills += bill.getTotalPrice();
            }
            if(totalMoneyAllBills!= this.totalMoney){
                System.out.println("Inventory check made. Money do not match");
            }
            else{
                System.out.println("Inventory check was made: Money match");
            }
        }finally {
            lock.unlock();
        }
    }
    @Override
    public String toString() {
        return "Inventory{" +
                "Products=" + products +
                ", TotalMoney=" + totalMoney +
                '}';
    }

}
