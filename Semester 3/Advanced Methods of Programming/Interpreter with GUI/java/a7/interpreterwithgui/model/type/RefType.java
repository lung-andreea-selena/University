package a7.interpreterwithgui.model.type;
import a7.interpreterwithgui.model.value.RefValue;
import a7.interpreterwithgui.model.value.Value;

public class RefType implements Type{
    private final Type inner;
    public RefType(Type inner)
    {
        this.inner = inner;
    }
    public Type getInner()
    {
        return this.inner;
    }

    @Override
    public boolean equals(Type anotherType)
    {
        if(anotherType instanceof RefType)
            return inner.equals(((RefType) anotherType).getInner());
        else
            return false;
    }
    @Override
    public Value defaultValue()
    {
        return new RefValue(0, inner);
    }
    @Override
    public Type deepCopy()
    {
        return new RefType(inner.deepCopy());
    }
    @Override
    public String toString()
    {
        return "RefType("+inner+")";
    }
}
