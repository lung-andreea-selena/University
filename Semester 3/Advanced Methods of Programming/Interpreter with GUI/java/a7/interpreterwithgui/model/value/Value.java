package a7.interpreterwithgui.model.value;
 import a7.interpreterwithgui.model.type.Type;
public interface Value {
    Type getType();
    Value deepCopy();
}
