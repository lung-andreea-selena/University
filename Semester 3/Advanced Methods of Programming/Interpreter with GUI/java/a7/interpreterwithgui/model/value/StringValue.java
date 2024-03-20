package a7.interpreterwithgui.model.value;
import a7.interpreterwithgui.model.type.StringType;
import a7.interpreterwithgui.model.type.Type;
public class StringValue implements Value {
    private final String value;
    public StringValue(String value)
    {
        this.value=value;
    }
    @Override
    public Type getType()
    {
        return new StringType();
    }
    @Override
    public boolean equals(Object anotherValue)
    {
        if(!(anotherValue instanceof StringValue))
            return false;
        StringValue castValue = (StringValue) anotherValue;
        return this.value.equals(castValue.value);
    }
    @Override
    public Value deepCopy()
    {
        return new StringValue(value);
    }
    public String getVal()
    {
        return this.value;
    }
    @Override
    public String toString()
    {
        return "StrinValue( "+ this.value+")";
    }
}
