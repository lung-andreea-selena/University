package a7.interpreterwithgui.model.expression;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyHeap;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.BoolValue;
import a7.interpreterwithgui.model.value.Value;

public class NotExp implements IExp{
    private final IExp exp;

    public NotExp(IExp exp)
    {
        this.exp=exp;
    }
    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        return exp.typeCheck(typeEnv);
    }

    @Override
    public Value eval(MyIDictionary<String,Value>table, MyIHeap heap) throws MyException
    {
        BoolValue val=(BoolValue) exp.eval(table,heap);
        if(!val.getValue())
            return new BoolValue(true);
        else
            return new BoolValue(false);
    }
    @Override
    public IExp deepCopy()
    {
        return new NotExp(exp.deepCopy());
    }
    @Override
    public String toString()
    {
        return String.format("!(%s)", exp);
    }
}
