package model.adt;

import exception.MyException;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Stack;

public class MyStack<T> implements MyIStack<T> {
    Stack<T> stack;
    public MyStack()
    {
        this.stack = new Stack<T>();
    }

    @Override
    public T pop() throws MyException
    {
        if(stack.isEmpty())
            throw new MyException("Stack is empty!");
        return this.stack.pop();
    }
    @Override
    public T peek() throws MyException //this function lets you retrieve the element at the top of the stack without removing it
    {
        if(stack.isEmpty())
            throw new MyException("The stack is empty");
        return stack.peek();
    }

    @Override
    public void push(T e)
    {
        this.stack.push(e);
    }

    @Override
    public boolean isEmpty()
    {
        return this.stack.isEmpty();
    }

    @Override
    public List<T> getReversed()
    {
        List<T> list = Arrays.asList((T[]) stack.toArray());
        Collections.reverse(list);
        return list;
    }

    @Override
    public String toString()
    {
        return "MyStack{" + "stack" + stack + '}';
    }

    public Stack<T> getStack()
    {
        return stack;
    }
    public void setStack(Stack<T> stack)
    {
        this.stack=stack;
    }
}
