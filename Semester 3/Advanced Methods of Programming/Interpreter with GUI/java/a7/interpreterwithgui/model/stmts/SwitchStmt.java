package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.expression.RelExp;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.Value;

public class SwitchStmt implements IStmt{
    private final IExp bigExpr;
    private final IExp exp1;
    private final IExp exp2;
    private final IStmt stmt1;
    private final IStmt stmt2;
    private final IStmt stmt3;

    public SwitchStmt(IExp bigExpr,IExp exp1,IStmt stmt1,IExp exp2,IStmt stmt2,IStmt stmt3)
    {
        this.bigExpr=bigExpr;
        this.exp1=exp1;
        this.stmt1=stmt1;
        this.exp2=exp2;
        this.stmt2=stmt2;
        this.stmt3=stmt3;
    }

    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIStack<IStmt> exeStack = state.getExeStack();
        IStmt statement = new IfStmt(new RelExp("==",bigExpr,exp1),stmt1,
                new IfStmt(new RelExp("==",bigExpr,exp2),stmt2,stmt3));
        exeStack.push(statement);
        state.setExeStack(exeStack);
        return null;
    }

    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type bigExpType = bigExpr.typeCheck(typeEnv);
        Type type1 = exp1.typeCheck(typeEnv);
        Type type2= exp2.typeCheck(typeEnv);
        if(bigExpType.equals(type1) && bigExpType.equals(type2))
        {
            stmt1.typeCheck(typeEnv.deepCopy());
            stmt2.typeCheck(typeEnv.deepCopy());
            stmt3.typeCheck(typeEnv.deepCopy());
            return typeEnv;
        }
        else
        {
            throw new MyException("The types do not match in the switch stmt");
        }
    }
    @Override
    public IStmt deepCopy()
    {
        return new SwitchStmt(bigExpr.deepCopy(),exp1.deepCopy(),stmt1.deepCopy(),exp2.deepCopy(),stmt2.deepCopy(),stmt3.deepCopy());
    }
    @Override
    public String toString()
    {
        return String.format("switch(%s){(case(%s): %s)(case(%s): %s)(default: %s)}", bigExpr, exp1, stmt1, exp2, stmt2, stmt3);
    }

}
