package model.stmts;
import exception.MyException;
import model.PrgState;
import model.adt.MyIDictionary;
import model.type.Type;

public class NopStmt implements IStmt {

    public NopStmt()
    {}
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        return typeEnv;
    }
    @Override
    public PrgState execute(PrgState state) {
        return null;
    }

    @Override
    public IStmt deepCopy() {
        return new NopStmt();
    }

    @Override
    public String toString() {
        return "NopStatement";
    }
}
