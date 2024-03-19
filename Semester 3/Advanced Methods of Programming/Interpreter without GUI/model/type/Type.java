package model.type;
import  model.value.Value;

public interface Type {
    boolean equals(Type otherType);
    Value defaultValue();
    Type deepCopy();

}
