package a7.interpreterwithgui.model.expression;
import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.type.RefType;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.RefValue;
import a7.interpreterwithgui.model.value.Value;

public class ReadHeapExpression implements IExp{
    private IExp expression;
    public ReadHeapExpression(IExp expression) {
        this.expression = expression;
    }
    @Override
    public Type typeCheck(MyIDictionary<String,Type> typeEnv) throws MyException
    {
        Type type= expression.typeCheck(typeEnv);
        if(type instanceof RefType)
        {
            RefType reftype=(RefType) type;
            return reftype.getInner();
        }
        else throw new MyException("The rh argument is not a RefType");
    }

    @Override
    public Value eval(MyIDictionary<String,Value> symtb,MyIHeap heap) throws MyException
    {
        Value value = expression.eval(symtb,heap);
        if(!(value instanceof RefValue))
            throw new MyException(String.format("%s not of RefType",value));
        RefValue refValue = (RefValue) value;
        return heap.get(refValue.getAddress());
    }
    @Override
    public IExp deepCopy() {
        return new ReadHeapExpression(expression.deepCopy());
    }
    @Override
    public String toString()
    {
        return "ReadHeap(" + expression.toString()+")";
    }
}
