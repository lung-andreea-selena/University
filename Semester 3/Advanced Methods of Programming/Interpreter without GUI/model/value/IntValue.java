package model.value;
import model.type.Type;
import model.type.IntType;
public class IntValue implements Value{
    private final int val;

    public IntValue(int val)
    {
        this.val=val;
    }
    public int getVal()
    {
        return this.val;
    }
    @Override
    public Type getType()
    {
        return new IntType();
    }

    @Override
    public Value deepCopy()
    {
        return new IntValue(val);
    }

    @Override
    public String toString()
    {
        return "IntValue{ "+this.val+'}';
    }


}
