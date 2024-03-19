package model.expression;
import model.adt.MyIDictionary;
import exception.MyException;
import model.adt.MyIHeap;
import model.type.Type;
import model.value.Value;

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
