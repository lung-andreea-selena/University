package model.stmts;

import exception.MyException;
import model.adt.MyDictionary;
import model.expression.IExp;
import model.PrgState;
import model.type.RefType;
import model.type.Type;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.value.RefValue;
import model.value.Value;

public class NewStmt implements IStmt {
    private final String varName;
    private final IExp expression;

    public NewStmt(String varName,IExp expression)
    {
        this.varName=varName;
        this.expression=expression;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIDictionary<String,Value> symtbl=state.getSymTable();
        MyIHeap heap = state.getHeap();
        if(!symtbl.isDefined(varName))
            throw new MyException(String.format("%s not in symtbl",varName));
        Value varValue = symtbl.lookUp(varName);
        if(!(varValue.getType() instanceof RefType))
            throw new MyException(String.format("%s not of RefType",varName));
        Value eval = expression.eval(symtbl,heap);
        Type locationType = ((RefValue)varValue).getLocationType();
        if(!locationType.equals(eval.getType()))
            throw new MyException(String.format("%s is not of %s",varName,eval.getType()));
        int newPos = heap.add(eval);
        symtbl.put(varName,new RefValue(newPos,locationType));
        state.setSymTable(symtbl);
        state.setHeap(heap);
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        Type typeVar= typeEnv.lookUp(varName);
        Type typeExpr= expression.typeCheck(typeEnv);
        if(typeVar.equals(new RefType(typeExpr)))
            return typeEnv;
        else throw new MyException("NewStmt: left and right sides have diff types");
    }
    @Override
    public IStmt deepCopy()
    {
        return new NewStmt(varName,expression.deepCopy());
    }
    @Override
    public String toString()
    {
        return "NewStmt("+varName+", "+expression+")";
    }
}
