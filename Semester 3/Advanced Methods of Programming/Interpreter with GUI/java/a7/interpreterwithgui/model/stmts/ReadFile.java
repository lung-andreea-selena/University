package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.type.IntType;
import a7.interpreterwithgui.model.type.StringType;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.IntValue;
import a7.interpreterwithgui.model.value.StringValue;
import a7.interpreterwithgui.model.value.Value;

import java.io.BufferedReader;
import java.io.IOException;
public class ReadFile implements IStmt{
    private final IExp exp;
    private final String varName;
    public ReadFile(IExp ex,String varName)
    {
        this.exp=ex;
        this.varName=varName;
    }
    @Override
    public PrgState execute(PrgState state) throws  MyException
    {
        MyIDictionary<String,Value> symtbl=state.getSymTable();
        MyIDictionary<String,BufferedReader> fileTable=state.getFileTable();
        if(symtbl.isDefined(varName))
        {
            Value value = symtbl.lookUp(varName);
            if(value.getType().equals(new IntType()))
            {
                value=exp.eval(symtbl, state.getHeap());
                if(value.getType().equals(new StringType()))
                {
                    StringValue castValue = (StringValue) value;
                    if(fileTable.isDefined(castValue.getVal()))
                    {
                        BufferedReader br= fileTable.lookUp(castValue.getVal());
                        try
                        {
                            String line=br.readLine();
                            if(line==null)
                                line="0";
                            symtbl.put(varName,new IntValue(Integer.parseInt(line)));
                        }catch (IOException e)
                        {
                         throw new MyException(" could not read from file");
                        }
                    }else throw new MyException("the file table does not contain this");
                }else throw new MyException(" does not evaluate to StringType");
            }else throw new MyException("is not of type IntType");
        }else throw new MyException("is not present in the symtbl");
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        if(exp.typeCheck(typeEnv).equals(new StringType()))
        {
            if(typeEnv.lookUp(varName).equals(new IntType()))
                return typeEnv;
            else
                throw new MyException("ReadFile: requires an integer as its variable parameter");

        }
        else throw new MyException("ReadFile: requires a string as expression parameter");
    }
    @Override
    public IStmt deepCopy()
    {
        return new ReadFile(exp.deepCopy(),varName);
    }
    @Override
    public String toString()
    {
        return "ReadFile( "+this.exp.toString()+" "+this.varName+")";
    }
}
