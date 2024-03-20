package a7.interpreterwithgui.model.stmts;


import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.Type;

public class DoWhileStmt implements IStmt {
    private final IStmt stmt;
    private final IExp exp;

    public DoWhileStmt(IExp exp, IStmt stmt)
    {
        this.exp=exp;
        this.stmt=stmt;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        IStmt statement = new CompStmt(stmt,new WhileStmt(exp,stmt));
        state.getExeStack().push(statement);
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type= exp.typeCheck(typeEnv);
        if(type.equals(new BoolType()))
        {
            stmt.typeCheck(typeEnv.deepCopy());
            return typeEnv;
        }
        else throw new MyException("The condition in the do while statement is not valid, must be bool");
    }
    @Override
    public IStmt deepCopy()
    {
        return new DoWhileStmt(exp.deepCopy(),stmt.deepCopy());
    }
    @Override
    public String toString()
    {
        return String.format("do {%s} while (%s)", stmt, exp);
    }
}
