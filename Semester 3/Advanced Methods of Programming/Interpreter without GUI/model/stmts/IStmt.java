package model.stmts;

import exception.MyException;
import model.PrgState;
import model.adt.MyIDictionary;
import model.type.Type;

public interface IStmt {
    PrgState execute(PrgState state) throws MyException;
    MyIDictionary<String,Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException;
    IStmt deepCopy();
}
