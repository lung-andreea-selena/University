package model.expression;
import exception.MyException;
import model.adt.MyIHeap;
import model.value.Value;
import exception.MyException;
import model.adt.MyIDictionary;
import model.type.Type;
public interface IExp {
    Value eval(MyIDictionary<String,Value> tbl, MyIHeap heap) throws MyException;
    IExp deepCopy();
    Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException;
}
