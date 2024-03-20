package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.type.Type;

public class SleepStmt implements IStmt{
    private final int value;
    public SleepStmt(int value)
    {
        this.value=value;
    }

    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        if(value!=0)
        {
            MyIStack<IStmt> exeStack= state.getExeStack();
            exeStack.push(new SleepStmt(value - 1));
            state.setExeStack(exeStack);
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
        return new SleepStmt(value);
    }
    @Override
    public String toString()
    {
        return String.format("sleep(%s)", value);
    }

}
