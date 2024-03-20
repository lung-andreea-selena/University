package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.expression.ValExp;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.IntValue;

public class WaitStmt implements IStmt{
    private final int value;
    public WaitStmt(int value)
    {
        this.value=value;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        if(value!=0)
        {
            MyIStack<IStmt> exeStack = state.getExeStack();
            exeStack.push(new CompStmt(new PrintStmt(new ValExp(new IntValue(value))), new WaitStmt(value-1)));
        }
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        return typeEnv;
    }
    @Override
    public IStmt deepCopy()
    {
        return new WaitStmt(value);
    }
    @Override
    public String toString()
    {
        return String.format("wait(%s)",value);
    }
}
