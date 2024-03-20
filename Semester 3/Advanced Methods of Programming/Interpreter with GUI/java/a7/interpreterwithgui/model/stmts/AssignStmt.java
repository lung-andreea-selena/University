package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.Value;
public class AssignStmt implements IStmt{
    private final String id;
    private final IExp expression;

    public AssignStmt(String i, IExp expr)
    {
        this.id=i;
        this.expression=expr;
    }

    @Override
    public MyIDictionary<String,Type> typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type typeVar=typeEnv.lookUp(id);
        Type typeExpr= expression.typeCheck(typeEnv);
        if(typeVar.equals(typeExpr))
            return typeEnv;
        else
            throw new MyException("AssignStmt : Left side and right side have different types");
    }

    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIStack<IStmt> stk=state.getExeStack();
        MyIDictionary<String,Value> symTbl=state.getSymTable();
        if(symTbl.isDefined(id))
        {
            Value val= expression.eval(symTbl, state.getHeap());
            Type typId=(symTbl.lookUp(id)).getType();
            if(val.getType().equals(typId))
            {
                symTbl.update(id, val);//the update
            }
                else
                    throw new MyException("declared type of variable " + id + " and type" +
                            " of the assigned expression do not match ");
        }
        else throw new MyException("the used variable " + id + " was not declared before");
        state.setSymTable(symTbl);
        return null;
    }

    @Override
    public IStmt deepCopy()
    {
        return new AssignStmt(id,expression.deepCopy());
    }

    @Override
    public String toString()
    {
        return "AssignStmt(" + id + "=" + expression+")";
    }
}
