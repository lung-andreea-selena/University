package a7.interpreterwithgui.model.expression;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.Value;
public interface IExp {
    Value eval(MyIDictionary<String,Value> tbl, MyIHeap heap) throws MyException;
    IExp deepCopy();
    Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException;
}
