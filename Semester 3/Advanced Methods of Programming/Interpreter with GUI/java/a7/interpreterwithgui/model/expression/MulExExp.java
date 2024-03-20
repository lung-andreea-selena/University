package a7.interpreterwithgui.model.expression;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.type.IntType;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.Value;

public class MulExExp implements IExp{
    private final IExp exp1;
    private final IExp exp2;

    public MulExExp(IExp exp1,IExp exp2)
    {
        this.exp1=exp1;
        this.exp2=exp2;
    }
    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type1 = exp1.typeCheck(typeEnv);
        Type type2= exp2.typeCheck(typeEnv);
        if(type1.equals(new IntType()) && type2.equals(new IntType()))
            return new IntType();
        else
            throw new MyException("In the Mulexp the expression is supposed to be int type");

    }
    @Override
    public Value eval(MyIDictionary<String,Value> table, MyIHeap heap) throws MyException
    {
        IExp expression= new ArithExp('-',new ArithExp('*',exp1,exp2),new ArithExp('+',exp1,exp2));
        return expression.eval(table,heap);
    }
    @Override
    public IExp deepCopy()
    {
        return new MulExExp(exp1.deepCopy(),exp2.deepCopy());
    }
    @Override
    public String toString()
    {
        return String.format("MUL(%s, %s)", exp1, exp2);
    }
}
