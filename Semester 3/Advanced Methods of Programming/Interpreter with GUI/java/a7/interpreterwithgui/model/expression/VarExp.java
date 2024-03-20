package a7.interpreterwithgui.model.expression;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.Value;

public class VarExp implements IExp{
    String key;
    public VarExp(String key)
    {
        this.key=key;
    }

    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        return typeEnv.lookUp(key);
    }
    @Override
    public Value eval(MyIDictionary<String,Value> tbl, MyIHeap heap) throws MyException
    {
        return tbl.lookUp(key);
    }

    @Override
    public IExp deepCopy()
    {
        return new VarExp(key);
    }

    @Override
    public String toString()
    {
        return key;
    }
}
