package model.stmts;
import model.adt.MyIDictionary;
import model.adt.MyIList;
import model.expression.IExp;
import model.PrgState;
import exception.MyException;
import model.type.Type;
import model.value.Value;

public class PrintStmt implements IStmt{
    IExp expression;

    public PrintStmt(IExp exp)
    {
        this.expression=exp;
    }

    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIList<Value> out = state.getOut();
        out.add(expression.eval(state.getSymTable(), state.getHeap()));
        state.setOut(out);
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        expression.typeCheck(typeEnv);
        return typeEnv;
    }

    @Override
    public IStmt deepCopy()
    {
        return new PrintStmt(expression.deepCopy());
    }

    @Override
    public String toString()
    {
        return "PrintStmt( "+ expression.toString() +')';
    }

}
