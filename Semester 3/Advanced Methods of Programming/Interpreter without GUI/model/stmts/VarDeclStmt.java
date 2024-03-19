package model.stmts;

import exception.MyException;
import model.PrgState;
import model.adt.MyIDictionary;
import model.type.Type;
import model.value.Value;

public class VarDeclStmt implements IStmt{
    String name;
    Type typ;

    public VarDeclStmt(String nm, Type ty)
    {
        this.name=nm;
        this.typ=ty;
    }

    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        typeEnv.put(name,typ);
        return typeEnv;
    }

    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIDictionary<String,Value>  symtbl= state.getSymTable();
        if(symtbl.isDefined(name))
        {
            throw new MyException("Variable " + name + " already exists in the symTable");
        }
        symtbl.put(name,typ.defaultValue());
        state.setSymTable(symtbl);
        return null;
    }

    @Override
    public IStmt deepCopy()
    {
        return new VarDeclStmt(name,typ);
    }

    @Override
    public String toString()
    {
        return "VarDecl( "+typ.toString()+" "+name+")";
    }
}
