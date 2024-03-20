package a7.interpreterwithgui.model.stmts;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIStack;
import a7.interpreterwithgui.model.expression.IExp;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.Type;
import a7.interpreterwithgui.model.value.BoolValue;
import a7.interpreterwithgui.model.value.Value;
public class WhileStmt implements IStmt {
    private final IExp expression;
    private final IStmt statement;

    public WhileStmt(IExp expression, IStmt statement) {
        this.expression = expression;
        this.statement = statement;
    }

    @Override
    public PrgState execute(PrgState state) throws MyException {
        Value value = expression.eval(state.getSymTable(), state.getHeap());
        MyIStack<IStmt> stack = state.getExeStack();
        if (!value.getType().equals(new BoolType()))
            throw new MyException(String.format("%s is not of BoolType", value));
        BoolValue boolValue = (BoolValue) value;
        if (boolValue.getValue()) {
            stack.push(this);
            stack.push(statement);
        }
        return null;
    }
    @Override
    public MyIDictionary<String, Type> typeCheck(MyIDictionary<String, Type> typeEnv) throws MyException
    {
        Type typeExpr = expression.typeCheck(typeEnv);
        if(typeExpr.equals(new BoolType()))
        {
            statement.typeCheck(typeEnv.deepCopy());
            return typeEnv;
        }
        else throw new MyException("WhileStmt: The condition does not have the type bool");
    }

    @Override
    public IStmt deepCopy() {
        return new WhileStmt(expression.deepCopy(), statement.deepCopy());
    }

    @Override
    public String toString() {
        return "WhileStmt("+ expression.toString()+"){"+statement.toString()+"}";
    }
}
