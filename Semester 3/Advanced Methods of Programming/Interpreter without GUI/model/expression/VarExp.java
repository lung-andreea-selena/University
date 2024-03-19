package model.expression;

import model.adt.MyIDictionary;
import exception.MyException;
import model.adt.MyIHeap;
import model.type.Type;
import model.value.Value;

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
