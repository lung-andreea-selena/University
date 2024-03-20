package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.expression.VarExp;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.Type;

public class CondAssignStmt implements IStmt{
    private final String variable;
    private final IExp exp1;
    private final IExp exp2;
    private final IExp exp3;
    public CondAssignStmt(String variable, IExp exp1,IExp exp2, IExp exp3)
    {
        this.variable=variable;
        this.exp1=exp1;
        this.exp2=exp2;
        this.exp3=exp3;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIStack<IStmt> exeSatck=state.getExeStack();
        IStmt statement=new IfStmt(exp1,new AssignStmt(variable,exp2),new AssignStmt(variable,exp3));
        exeSatck.push(statement);
        state.setExeStack(exeSatck);
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type varType=new VarExp(variable).typeCheck(typeEnv);
        Type type1= exp1.typeCheck(typeEnv);
        Type type2= exp2.typeCheck(typeEnv);
        Type type3= exp3.typeCheck(typeEnv);
        if(type1.equals(new BoolType()) && type2.equals(varType) && type3.equals(varType))
        {
            return typeEnv;
        }
        else
            throw new MyException("The types for Conditional Assignment are not valid");
    }
    @Override
    public IStmt deepCopy()
    {
        return new CondAssignStmt(variable,exp1.deepCopy(),exp2.deepCopy(),exp3.deepCopy());
    }
    @Override
    public String toString()
    {
        return String.format("%s=(%s)? %s: %s", variable, exp1, exp2, exp3);
    }
}
