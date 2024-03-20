package a7.interpreterwithgui.model.expression;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.IntType;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.BoolValue;
import a7.interpreterwithgui.model.value.IntValue;
import a7.interpreterwithgui.model.value.Value;

import java.util.Objects;

public class RelExp implements IExp{
    IExp exp1;
    IExp exp2;
    String operator;

    public RelExp(String op,IExp ex1,IExp ex2)
    {
        this.exp1=ex1;
        this.exp2=ex2;
        this.operator=op;
    }
    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type1, type2;
        type1 = exp1.typeCheck(typeEnv);
        type2=exp2.typeCheck(typeEnv);
        if(type1.equals(new IntType()))
        {
            if(type2.equals(new IntType()))
                return new BoolType();
            else throw new MyException("Second exp is not an integer");
        }
        else throw new MyException("First exp is not an integer");
    }

    @Override
    public Value eval(MyIDictionary<String,Value> symtbl, MyIHeap heap) throws MyException
    {
        Value value1,value2;
        value1=this.exp1.eval(symtbl,heap);
        if(value1.getType().equals(new IntType()))
        {
            value2=this.exp2.eval(symtbl,heap);
            if(value2.getType().equals(new IntType())) {
                IntValue val1 = (IntValue) value1;
                IntValue val2 = (IntValue) value2;
                int v1, v2;
                v1 = val1.getVal();
                v2 = val2.getVal();
                if (Objects.equals(this.operator, "<"))
                    return new BoolValue(v1 < v2);
                else if (Objects.equals(this.operator, "<="))
                    return new BoolValue(v1 <= v2);
                else if (Objects.equals(this.operator, "=="))
                    return new BoolValue(v1 == v2);
                else if (Objects.equals(this.operator, "!="))
                    return new BoolValue(v1 != v2);
                else if (Objects.equals(this.operator, ">"))
                    return new BoolValue(v1 > v2);
                else if (Objects.equals(this.operator, ">="))
                    return new BoolValue(v1 >= v2);
                throw new MyException("The operand is not a rel exp");
            }else throw new MyException("Second operand is not an integer");

        }else throw new MyException("First operand is not an integer");
    }

    @Override
    public IExp deepCopy()
    {
        return new RelExp(operator,exp1.deepCopy(),exp2.deepCopy());
    }

    @Override
    public String toString()
    {
        return "RelExp( "+ this.exp1.toString()+" "+this.operator+ " "+this.exp2.toString()+")";
    }
}
