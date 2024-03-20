package a7.interpreterwithgui.model.type;

import a7.interpreterwithgui.model.value.Value;

public interface Type {
    boolean equals(Type otherType);
    Value defaultValue();
    Type deepCopy();

}
