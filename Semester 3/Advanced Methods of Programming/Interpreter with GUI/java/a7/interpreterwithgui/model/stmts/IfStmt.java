package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.BoolValue;
import a7.interpreterwithgui.model.value.Value;

public class IfStmt implements IStmt{
    IExp expression;
    IStmt thenStmt;
    IStmt elseStmt;

    public IfStmt(IExp exp,IStmt thenS,IStmt elseS)
    {
        this.expression=exp;
        this.thenStmt=thenS;
        this.elseStmt=elseS;
    }

    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        Value result = this.expression.eval(state.getSymTable(), state.getHeap());
        if(result.getType().equals(new BoolType()))
        {
            IStmt stmt;
            BoolValue boolRes = (BoolValue) result;
            if(boolRes.getValue())
            {
                stmt= thenStmt;
            }
            else {stmt=elseStmt;}
            MyIStack<IStmt> stack = state.getExeStack();
            stack.push(stmt);
            state.setExeStack(stack);
            return null;
        }
        else throw new MyException("There is not a boolean expression in the if statement");
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        Type typeExpr = expression.typeCheck(typeEnv);
        if(typeExpr.equals(new BoolType()))
        {
            thenStmt.typeCheck(typeEnv.deepCopy());
            elseStmt.typeCheck(typeEnv.deepCopy());
            return typeEnv;
        }
        else throw new MyException("ifStmt: the condition of if does not have the type bool");
    }

    @Override
    public IStmt deepCopy()
    {
        return new IfStmt(expression.deepCopy(),thenStmt.deepCopy(),elseStmt.deepCopy());
    }

    @Override
    public String toString()
    {
        return "IfStmt(" +expression.toString()+" "+thenStmt.toString()+" else "+elseStmt;
    }
}
