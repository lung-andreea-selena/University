package model;
import model.Product;
import java.util.List;
import java.util.ArrayList;
public class Bill {
    List<Product> products;
    double totalPrice;

    public Bill(){
        products = new ArrayList<>();
        totalPrice = 0;
    }
    public void addProduct(Product product){
        this.products.add(product);
    }

    public void addMoney(double money){
        this.totalPrice= this.totalPrice + money;
    }

    public double getTotalPrice(){
        return this.totalPrice;
    }

    @Override
    public String toString() {
        return "Bill has been issued successfully!" + '\n' + "TotalPrice {$" + this.totalPrice + "}";
    }
}
