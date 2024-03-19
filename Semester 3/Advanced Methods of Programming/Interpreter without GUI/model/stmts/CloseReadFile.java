package model.stmts;
import exception.MyException;
import model.expression.IExp;
import model.PrgState;
import model.type.StringType;
import model.adt.MyIDictionary;
import model.type.Type;
import model.value.Value;
import model.value.StringValue;

import java.io.BufferedReader;
import java.io.IOException;

public class CloseReadFile implements IStmt{
    private final IExp exp;

    public CloseReadFile(IExp exp)
    {
        this.exp=exp;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        Value value = exp.eval(state.getSymTable(), state.getHeap());
        if(!value.getType().equals(new StringType()))
            throw new MyException("this expression does not evaluate to StringValue");
        StringValue fileName=(StringValue) value;
        MyIDictionary<String,BufferedReader> fileTable=state.getFileTable();
        if(!fileTable.isDefined(fileName.getVal()))
            throw new MyException("The value is not present in the fileTable");
        BufferedReader br = fileTable.lookUp(fileName.getVal());
        try{
            br.close();
        }catch (IOException e)
        {throw new MyException("Unexpected error in closing value");}
        fileTable.remove(fileName.getVal());
        state.setFileTable(fileTable);
        return null;
    }

    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        if(exp.typeCheck(typeEnv).equals(new StringType()))
            return typeEnv;
        else
            throw new MyException("CloseReadFile: requires a string expression");
    }

    @Override
    public IStmt deepCopy()
    {
        return new CloseReadFile(exp.deepCopy());
    }
    @Override
    public String toString()
    {
        return "CloseReadFile( "+ this.exp.toString()+")";
    }
}
