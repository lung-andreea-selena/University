package model.expression;

import exception.MyException;
import model.adt.MyIHeap;
import model.type.BoolType;
import model.adt.MyIDictionary;
import model.type.Type;
import model.value.BoolValue;
import model.value.Value;

import java.util.Objects;

public class LogicExp implements IExp{
    IExp ex1;
    IExp ex2;
    char op;

    public LogicExp(char op,IExp e1, IExp e2)
    {
        this.op=op;
        this.ex1=e1;
        this.ex2=e2;

    }
    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type1,type2;
        type1=ex1.typeCheck(typeEnv);
        type2=ex2.typeCheck(typeEnv);
        if(type1.equals(new BoolType()))
        {
            if(type2.equals(new BoolType()))
                return new BoolType();
            else throw new MyException("The second operand is not bool type");
        }
        else throw new MyException("The first operand is not bool type");
    }

    @Override
    public Value eval(MyIDictionary<String,Value> tbl, MyIHeap heap) throws MyException
    {
        Value v1,v2;
        v1=this.ex1.eval(tbl,heap);
        if(v1.getType().equals(new BoolType()))
        {
            v2=this.ex2.eval(tbl,heap);
            if(v2.getType().equals(new BoolType()))
            {
                BoolValue bool1= (BoolValue) v1;
                BoolValue bool2=(BoolValue) v2;
                boolean b1,b2;
                b1=bool1.getValue();
                b2=bool2.getValue();
                if(op=='&') return new BoolValue(b1 && b2);
                if(op=='|') return new BoolValue(b1||b2);
                throw new MyException("No operation for logical exp");
            }
            else throw new MyException("Second operand is not boolean");
        }
        else throw new MyException("First operand is not boolean");
    }

    @Override
    public IExp deepCopy()
    {
        return new LogicExp(op,ex1.deepCopy(),ex2.deepCopy());
    }

    @Override
    public String toString()
    {
        return ex1.toString()+" "+ op+" "+ex2.toString();
    }
}
