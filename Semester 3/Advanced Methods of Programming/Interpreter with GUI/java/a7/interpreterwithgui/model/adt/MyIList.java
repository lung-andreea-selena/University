package a7.interpreterwithgui.model.adt;

import java.util.List;

public interface MyIList<T>{
    void add(T e);
    void clear();
    List<T> getList();
}
