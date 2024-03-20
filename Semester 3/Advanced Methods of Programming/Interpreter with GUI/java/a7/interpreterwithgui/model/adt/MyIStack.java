package a7.interpreterwithgui.model.adt;

import a7.interpreterwithgui.exception.MyException;

import java.util.List;

public interface MyIStack <T>{
    T pop() throws MyException;
    void push(T e);

    boolean isEmpty();

    List<T> getReversed();
    T peek() throws MyException;
}

