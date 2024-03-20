package a7.interpreterwithgui.model.type;

import a7.interpreterwithgui.model.value.StringValue;
import a7.interpreterwithgui.model.value.Value;

public class StringType implements Type{
    @Override
    public boolean equals(Type anotherType)
    {
        return anotherType instanceof StringType;
    }
    @Override
    public Value defaultValue()
    {
        return new StringValue("");
    }
    @Override
    public Type deepCopy(){
        return new StringType();
    }
    @Override
    public String toString()
    {
        return "string";
    }
}
