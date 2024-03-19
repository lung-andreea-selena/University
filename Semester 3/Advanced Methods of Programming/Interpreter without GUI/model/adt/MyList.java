package model.adt;

import java.util.List;
import java.util.LinkedList;

public class MyList<T> implements MyIList<T> {
    private List<T> output;

    public MyList()
    {
        output = new LinkedList<>();
    }

    @Override
    public void add(T e)
    {
        output.add(e);
    }

    @Override
    public void clear()
    {
        output.clear();
    }

    @Override
    public String toString()
    {
        return "MyList{" + "output=" + output + '}';
    }

    public List<T> getOutput()
    {
        return output;
    }

    public void setOutput(List<T> output)
    {
        this.output = output;
    }
}
