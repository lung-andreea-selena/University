package model.stmts;
import exception.MyException;
import model.expression.IExp;
import model.PrgState;
import model.adt.MyIDictionary;
import model.adt.MyIHeap;
import model.type.RefType;
import model.type.Type;
import model.value.Value;
import model.value.RefValue;
public class WriteHeap implements IStmt {
    private final String varName;
    private final IExp expression;
    public WriteHeap(String varName,IExp expr)
    {
        this.varName=varName;
        this.expression=expr;
    }
    @Override
    public PrgState execute(PrgState state) throws MyException
    {
        MyIDictionary<String, Value> symTable = state.getSymTable();
        MyIHeap heap = state.getHeap();
        if (!symTable.isDefined(varName))
            throw new MyException(String.format("%s not present in the symTable", varName));
        Value value = symTable.lookUp(varName);
        if (!(value instanceof RefValue))
            throw new MyException(String.format("%s not of RefType", value));
        RefValue refValue = (RefValue) value;
        Value evaluated = expression.eval(symTable, heap);
        if (!evaluated.getType().equals(refValue.getLocationType()))
            throw new MyException(String.format("%s not of %s", evaluated, refValue.getLocationType()));
        heap.update(refValue.getAddress(), evaluated);
        state.setHeap(heap);
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        if(typeEnv.lookUp(varName).equals(new RefType(expression.typeCheck(typeEnv))))
            return typeEnv;
        else throw new MyException("WriteHeapStmt: right and lest side are two different types");
    }
    @Override
    public IStmt deepCopy()
    {
        return new WriteHeap(varName,expression.deepCopy());
    }
    @Override
    public String toString()
    {
        return "WriteHeap("+varName+", "+expression.toString()+")";
    }
}
