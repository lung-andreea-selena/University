package exception;

public class ProductNotFound  extends Exception {
    public ProductNotFound() {
        super("Product not found");
    }
}