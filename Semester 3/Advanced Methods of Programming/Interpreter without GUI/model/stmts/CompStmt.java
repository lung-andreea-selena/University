package model.stmts;
import exception.MyException;
import model.PrgState;
import model.adt.MyIDictionary;
import model.adt.MyIStack;
import model.type.Type;

import java.lang.reflect.MalformedParameterizedTypeException;


public class CompStmt implements IStmt{
    IStmt stmt1;
    IStmt stmt2;

    public CompStmt(IStmt st1,IStmt st2)
    {
        this.stmt1=st1;
        this.stmt2=st2;
    }

    @Override
    public PrgState execute(PrgState state)
    {
        MyIStack<IStmt> stack = state.getExeStack();
        stack.push(stmt2);
        stack.push(stmt1);
        state.setExeStack(stack);
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        return stmt2.typeCheck(stmt1.typeCheck(typeEnv));
    }

    @Override
    public IStmt deepCopy()
    {
        return new CompStmt(stmt1.deepCopy(),stmt2.deepCopy());
    }

    @Override
    public String toString()
    {
        return "CompStmt( "+ stmt1.toString() + ", "+stmt2.toString()+")";
    }
}
