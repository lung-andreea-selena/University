package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.type.StringType;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.StringValue;
import a7.interpreterwithgui.model.value.Value;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;

public class OpenReadFile implements IStmt{
    private final IExp exp;
    public OpenReadFile(IExp exp)
    {
        this.exp=exp;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        Value value=exp.eval(state.getSymTable(), state.getHeap());
        if(value.getType().equals(new StringType()))
        {
            StringValue fileName=(StringValue) value;
            MyIDictionary<String,BufferedReader> fileTable = state.getFileTable();
            if(!fileTable.isDefined(fileName.getVal()))
            {
                BufferedReader br;
                try{
                    br=new BufferedReader(new FileReader(fileName.getVal()));
                }catch(FileNotFoundException e)
                {
                    throw new MyException("could not be opened");
                }
                fileTable.put(fileName.getVal(),br);
                state.setFileTable(fileTable);
            }else throw new MyException("is already opened");
        }else throw new MyException(" does not evaluate to StringType");
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        if(exp.typeCheck(typeEnv).equals(new StringType()))
            return typeEnv;
        else throw new MyException("OpenReadFile: requires a string expression");
    }
    @Override
    public IStmt deepCopy()
    {
        return new OpenReadFile(exp.deepCopy());
    }
    @Override
    public String toString()
    {
        return "OpenReadFile( "+this.exp.toString()+")";
    }
}
