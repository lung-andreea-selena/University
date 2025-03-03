package exception;

public class QuantityException extends Exception {
    public QuantityException() {
        System.out.println("Quantity is not enough");
    }
}