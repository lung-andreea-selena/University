package model.expression;
import model.type.IntType;
import model.type.Type;
import model.value.Value;
import model.adt.MyIDictionary;
import exception.MyException;
import model.value.IntValue;
import model.adt.MyIHeap;

public class ArithExp implements IExp{
    IExp e1;
    IExp e2;
    char op;

    public ArithExp(char op,IExp e1, IExp e2)
    {
        this.e1=e1;
        this.e2=e2;
        this.op=op;
    }
    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type1, type2;
        type1 = e1.typeCheck(typeEnv);
        type2 = e2.typeCheck(typeEnv);
        if(type1.equals(new IntType()))
        {
            if(type2.equals(new IntType()))
                return new IntType();
            else throw new MyException("Second operand is not an integer");
        }
        else throw new MyException("First operand is not an integer");
    }

    @Override
    public Value eval(MyIDictionary<String,Value> tbl,MyIHeap heap) throws MyException
    {
        Value v1,v2;
        v1 = e1.eval(tbl,heap);
        if(v1.getType().equals(new IntType()))
        {
            v2=e2.eval(tbl,heap);
            if(v2.getType().equals(new IntType()))
            {
                IntValue i1 = (IntValue) v1;
                IntValue i2 = (IntValue) v2;
                int n1,n2;
                n1=i1.getVal();
                n2= i2.getVal();
                if(op=='+') return new IntValue(n1+n2);
                if(op=='-') return new IntValue(n1-n2);
                if(op=='*') return new IntValue(n1*n2);
                if(op=='/')
                {
                    if(n2==0)
                        throw new MyException("division by zero");
                    else return new IntValue(n1/n2);

                }
            }
            else throw new MyException("second operand is not an integer");
        }
        throw new MyException("first operand is not an integer");
    }

    @Override
    public IExp deepCopy()
    {
        return new ArithExp(op,e1.deepCopy(),e2.deepCopy());
    }

    @Override
    public String toString()
    {
        return e1.toString() + " "+ op+" "+e2.toString();
    }
}
