package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyDictionary;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.expression.RelExp;
import a7.interpreterwithgui.model.expression.VarExp;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.type.IntType;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;

public class ForStmt implements IStmt {
    private final String variable;
    private final IExp exp1;
    private final IExp exp2;
    private final IExp exp3;
    private final IStmt stmt;

    public ForStmt(String variable,IExp exp1,IExp exp2,IExp exp3,IStmt stmt)
    {
        this.variable=variable;
        this.exp1=exp1;
        this.exp2=exp2;
        this.exp3=exp3;
        this.stmt=stmt;
    }

    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIStack<IStmt> exeStack = state.getExeStack();
        IStmt statement = new CompStmt(new AssignStmt("v",exp1),
                new WhileStmt(new RelExp("<",new VarExp("v"),exp2),new CompStmt(stmt,new AssignStmt("v",exp3))));
        exeStack.push(statement);
        state.setExeStack(exeStack);
        return null;
    }

    @Override
    public MyIDictionary<String,Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type1 = exp1.typeCheck(typeEnv);
        Type type2 = exp2.typeCheck(typeEnv);
        Type type3 = exp3.typeCheck(typeEnv);

        if (type1.equals(new IntType()) && type2.equals(new IntType()) && type3.equals(new IntType()))
            return typeEnv;
        else
            throw new MyException("For stmt does not contain valid types");
    }

    @Override
    public IStmt deepCopy()
    {
        return new ForStmt(variable,exp1.deepCopy(),exp2.deepCopy(),exp3.deepCopy(),stmt.deepCopy());
    }

    @Override
    public String toString()
    {
        return "for("+variable+"="+exp1.toString()+";"+variable+"<"+exp2.toString()+";"+variable+"="+stmt.toString();
    }

}
