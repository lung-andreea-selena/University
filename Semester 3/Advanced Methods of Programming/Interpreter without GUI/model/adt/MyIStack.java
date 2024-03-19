package model.adt;
import java.util.List;
import exception.MyException;

public interface MyIStack <T>{
    T pop() throws MyException;
    void push(T e);

    boolean isEmpty();

    List<T> getReversed();
    T peek() throws MyException;
}

