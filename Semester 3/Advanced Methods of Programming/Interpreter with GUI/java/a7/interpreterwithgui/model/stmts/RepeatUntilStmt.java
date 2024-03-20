package a7.interpreterwithgui.model.stmts;


import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.expression.NotExp;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.Type;

public class RepeatUntilStmt implements IStmt{
    private final IStmt stmt;
    private final IExp exp;

    public RepeatUntilStmt(IStmt stmt,IExp exp)
    {
        this.stmt=stmt;
        this.exp=exp;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIStack<IStmt> exeStack=state.getExeStack();
        IStmt statement = new CompStmt(stmt,new WhileStmt(new NotExp(exp),stmt));
        exeStack.push(statement);
        state.setExeStack(exeStack);
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type = exp.typeCheck(typeEnv);
        if(type.equals(new BoolType()))
        {
            stmt.typeCheck(typeEnv.deepCopy());
            return typeEnv;
        }
        else
            throw new MyException("The expression in Repeat Until must be bool type");
    }

    @Override
    public IStmt deepCopy()
    {
        return new RepeatUntilStmt(stmt.deepCopy(),exp.deepCopy());
    }
    @Override
    public String toString()
    {
        return String.format("repeat(%s) until (%s)",stmt,exp);
    }
}
