package a7.interpreterwithgui.view;

public abstract class Command {
    private final String key;
    private final String description;
    public Command(String key,String desc)
    {
        this.key=key;
        this.description=desc;
    }
    public abstract void execute();
    public String getKey()
    {
        return this.key;
    }
    public String getDescription()
    {
        return this.description;
    }
}
