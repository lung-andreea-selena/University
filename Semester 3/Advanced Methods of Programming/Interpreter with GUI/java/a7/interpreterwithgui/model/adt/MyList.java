package a7.interpreterwithgui.model.adt;

import java.util.LinkedList;
import java.util.List;

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
    public List<T> getList() {
        synchronized (this) {
            return output;
        }
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
