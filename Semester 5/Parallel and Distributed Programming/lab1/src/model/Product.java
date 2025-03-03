package model;
import exception.QuantityException;
public class Product {
    String name;
    int price;
    int quantity;

    public Product(String name, int price, int quantity) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    public String getName() {
        return name;
    }

    public double getPrice() {
        return price;
    }

    synchronized void decrementQuantity(int quantity) throws QuantityException {
        if (quantity > this.quantity) {
            throw new QuantityException();

        }
        this.quantity -= quantity;
    }

    @Override
    public String toString() {
        return "Product{" +
                "Name='" + name + '\'' +
                ", Price=" + price +
                ", Quantity=" + quantity +
                '}';
    }
}

