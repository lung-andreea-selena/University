package model.stmts;
import exception.MyException;
import model.PrgState;
import model.type.Type;
import model.adt.*;
import model.value.Value;

import java.util.Map;
public class ForkStmt implements IStmt {
    private final IStmt stmt;
    public ForkStmt(IStmt stmt)
    {
        this.stmt=stmt;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIStack<IStmt> newStack = new MyStack<>();
        newStack.push(stmt);
        MyIDictionary<String,Value> newSymTable = new MyDictionary<>();
        for(Map.Entry<String,Value> entry: state.getSymTable().getContent().entrySet())
        {
            newSymTable.put(entry.getKey(),entry.getValue().deepCopy());
        }
        return new PrgState(newStack,newSymTable,state.getOut(),state.getFileTable(), state.getHeap());
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        stmt.typeCheck(typeEnv.deepCopy());
        return typeEnv;
    }
    @Override
    public IStmt deepCopy()
    {
       return new ForkStmt(stmt.deepCopy());
    }
    @Override
    public String toString()
    {
        return "ForkStmt( "+stmt+")";
    }
}
