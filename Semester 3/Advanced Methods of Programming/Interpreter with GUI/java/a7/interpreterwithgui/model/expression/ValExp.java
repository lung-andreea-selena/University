package a7.interpreterwithgui.model.expression;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.Value;

public class ValExp implements IExp{
    Value val;

    public ValExp(Value val)
    {
        this.val=val;
    }

    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        return val.getType();
    }

    @Override
    public Value eval(MyIDictionary<String,Value> tbl, MyIHeap heap) throws MyException
    {
        return this.val;
    }

    @Override
    public IExp deepCopy()
    {
        return new ValExp(val);
    }

    @Override
    public String toString()
    {
        return this.val.toString();
    }
}
