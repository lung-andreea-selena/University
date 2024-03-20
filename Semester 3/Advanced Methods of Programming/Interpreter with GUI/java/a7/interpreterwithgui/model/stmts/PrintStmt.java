package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIList;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.Value;

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
