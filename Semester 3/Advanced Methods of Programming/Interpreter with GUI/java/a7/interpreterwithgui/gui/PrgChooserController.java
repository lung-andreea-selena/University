package a7.interpreterwithgui.gui;

import a7.interpreterwithgui.controller.Controller;
import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyDictionary;
import a7.interpreterwithgui.model.adt.MyHeap;
import a7.interpreterwithgui.model.adt.MyList;
import a7.interpreterwithgui.model.adt.MyStack;
import a7.interpreterwithgui.model.expression.*;
import a7.interpreterwithgui.model.stmts.*;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.IntType;
import a7.interpreterwithgui.model.type.RefType;
import a7.interpreterwithgui.model.type.StringType;
import a7.interpreterwithgui.model.value.BoolValue;
import a7.interpreterwithgui.model.value.IntValue;
import a7.interpreterwithgui.model.value.StringValue;
import a7.interpreterwithgui.repository.IRepository;
import a7.interpreterwithgui.repository.Repository;
import a7.interpreterwithgui.view.RunExampleCommand;
import javafx.beans.Observable;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.ListView;
import javafx.scene.control.SelectionMode;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class PrgChooserController {

    private PrgExecutorController programExecutorController;
    public void setPrgExecutorController(PrgExecutorController programExecutorController )
    {
        this.programExecutorController=programExecutorController;
    }
    @FXML
    private ListView<IStmt> ListViewSelectPrg;

    @FXML
    public void initialize()
    {
        ListViewSelectPrg.setItems(getAllStatements());
        ListViewSelectPrg.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
    }

    @FXML
    private void displayProgram(ActionEvent actionEvent)
    {
        IStmt selectedStmt = ListViewSelectPrg.getSelectionModel().getSelectedItem();
        if(selectedStmt == null)
        {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("ERROR");
            alert.setContentText("No statement selected!");
            alert.showAndWait();
        }
        else
        {
            int id= ListViewSelectPrg.getSelectionModel().getSelectedIndex();
            try{
                selectedStmt.typeCheck(new MyDictionary<>());
                PrgState prgstate = new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),selectedStmt);
                IRepository repository = new Repository(prgstate, "log"+(id+1)+".txt");
                Controller controller = new Controller(repository);
                programExecutorController.setController(controller);
            }catch(MyException e)
            {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setTitle("ERROR");
                alert.setContentText(e.getMessage());
                alert.showAndWait();
            }
        }
    }

    @FXML
    private ObservableList<IStmt> getAllStatements()
    {
        List<IStmt> allStmts = new ArrayList<>();
        IStmt example1 = new CompStmt(new VarDeclStmt("v",new IntType()),
                new CompStmt(new AssignStmt("v",new ValExp(new IntValue(2))), new PrintStmt(new
                        VarExp("v"))));
        allStmts.add(example1);

        IStmt example2=  new CompStmt( new VarDeclStmt("a",new IntType()),
                new CompStmt(new VarDeclStmt("b",new IntType()),
                        new CompStmt(new AssignStmt("a", new ArithExp('+',new ValExp(new IntValue(2)),new
                                ArithExp('*',new ValExp(new IntValue(3)), new ValExp(new IntValue(5))))),
                                new CompStmt(new AssignStmt("b",new ArithExp('+',new VarExp("a"), new ValExp(new
                                        IntValue(1)))), new PrintStmt(new VarExp("b"))))));
        allStmts.add(example2);

        IStmt example3=  new CompStmt(new VarDeclStmt("a",new BoolType()),
                new CompStmt(new VarDeclStmt("v", new IntType()),
                        new CompStmt(new AssignStmt("a", new ValExp(new BoolValue(true))),
                                new CompStmt(new IfStmt(new VarExp("a"),new AssignStmt("v",new ValExp(new
                                        IntValue(2))), new AssignStmt("v", new ValExp(new IntValue(3)))), new PrintStmt(new
                                        VarExp("v"))))));
        allStmts.add(example3);

        IStmt example4 = new CompStmt(new VarDeclStmt("varf", new StringType()),
                new CompStmt(new AssignStmt("varf", new ValExp(new StringValue("test.in"))),
                        new CompStmt(new OpenReadFile(new VarExp("varf")),
                                new CompStmt(new VarDeclStmt("varc", new IntType()),
                                        new CompStmt(new ReadFile(new VarExp("varf"), "varc"),
                                                new CompStmt(new PrintStmt(new VarExp("varc")),
                                                        new CompStmt(new ReadFile(new VarExp("varf"), "varc"),
                                                                new CompStmt(new PrintStmt(new VarExp("varc")),
                                                                        new CloseReadFile(new VarExp("varf"))))))))));
        allStmts.add(example4);


        IStmt example5 = new CompStmt(new VarDeclStmt("a", new IntType()),
                new CompStmt(new VarDeclStmt("b", new IntType()),
                        new CompStmt(new AssignStmt("a", new ValExp(new IntValue(5))),
                                new CompStmt(new AssignStmt("b", new ValExp(new IntValue(7))),
                                        new IfStmt(new RelExp(">", new VarExp("a"),
                                                new VarExp("b")),new PrintStmt(new VarExp("a")),
                                                new PrintStmt(new VarExp("b")))))));
        allStmts.add(example5);


        IStmt ex6 = new CompStmt(new VarDeclStmt("v",new RefType(new IntType())),new CompStmt(new NewStmt("v",new ValExp(new IntValue(20))),
                new CompStmt(new VarDeclStmt("a",new RefType(new RefType(new IntType()))),new CompStmt(
                        new NewStmt("a",new VarExp("v")),new CompStmt(new PrintStmt(new VarExp("v")),
                        new PrintStmt(new VarExp("a")))))));
        allStmts.add(ex6);

        IStmt ex7= new CompStmt(
                new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(new NewStmt("v", new ValExp(new IntValue(20))),
                        new CompStmt(new VarDeclStmt("a", new RefType(new RefType(new IntType()))),
                                new CompStmt(new NewStmt("a", new VarExp("v")),
                                        new CompStmt(new NewStmt("v", new ValExp(new IntValue(30))),
                                                new PrintStmt(new ReadHeapExpression(new ReadHeapExpression(new VarExp("a")))))))));
        allStmts.add(ex7);


        IStmt ex8= new CompStmt(
                new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(
                        new NewStmt("v", new ValExp(new IntValue(20))),
                        new CompStmt(
                                new NewStmt("v", new ValExp(new IntValue(30))),
                                new PrintStmt(new ReadHeapExpression(new VarExp("v"))))));
        allStmts.add(ex8);


        IStmt exFork = new CompStmt(new VarDeclStmt("a", new RefType(new IntType())), new CompStmt(
                new VarDeclStmt("counter", new IntType()),
                new WhileStmt(new RelExp("<",new VarExp("counter"),
                        new ValExp(new IntValue(10))),
                        new CompStmt(
                                new ForkStmt(new ForkStmt(
                                        new CompStmt(
                                                new NewStmt("a",
                                                        new VarExp("counter")),
                                                new PrintStmt(new ReadHeapExpression(
                                                        new VarExp("a")))))),
                                new AssignStmt("counter", new ArithExp('+',
                                        new VarExp("counter"),
                                        new ValExp(new IntValue(1))))))));
        allStmts.add(exFork);

        //FOR STATEMENT
        IStmt exFor = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValExp(new IntValue(20))),
                        new CompStmt(new ForStmt("v", new ValExp(new IntValue(0)),
                                new ValExp(new IntValue(3)),
                                new ArithExp('+', new VarExp("v"), new ValExp(new IntValue(1))),
                                new ForkStmt(new CompStmt(new PrintStmt(new VarExp("v")),
                                        new AssignStmt("v", new ArithExp('+', new VarExp("v"), new ValExp(new IntValue(1))))))),
                                new PrintStmt(new ArithExp('*', new VarExp("v"), new ValExp(new IntValue(10)))))));
        allStmts.add(exFor);

        //SLEEP STATEMENT
        IStmt exSleep = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValExp(new IntValue(0))),
                        new CompStmt(new WhileStmt(new RelExp("<", new VarExp("v"), new ValExp(new IntValue(3))),
                                new CompStmt(new ForkStmt(new CompStmt(new PrintStmt(new VarExp("v")),
                                        new AssignStmt("v", new ArithExp('+', new VarExp("v"), new ValExp(new IntValue(1)))))),
                                        new AssignStmt("v", new ArithExp('+', new VarExp("v"), new ValExp(new IntValue(1)))))),
                                new CompStmt(new SleepStmt(5), new PrintStmt(new ArithExp('*', new VarExp("v"), new ValExp(new IntValue(10))))))));
        allStmts.add(exSleep);

        //WAIT STATEMENT
        IStmt exWait = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValExp(new IntValue(20))),
                        new CompStmt(new WaitStmt(10),
                                new PrintStmt(new ArithExp('*', new VarExp("v"), new ValExp(new IntValue(10)))))));
        allStmts.add(exWait);

        //SWITCH STATEMENT
        IStmt exSwitch = new CompStmt(new VarDeclStmt("a", new IntType()),
                new CompStmt(new VarDeclStmt("b", new IntType()),
                        new CompStmt(new VarDeclStmt("c", new IntType()),
                                new CompStmt(new AssignStmt("a", new ValExp(new IntValue(1))),
                                        new CompStmt(new AssignStmt("b", new ValExp(new IntValue(2))),
                                                new CompStmt(new AssignStmt("c", new ValExp(new IntValue(5))),
                                                        new CompStmt(new SwitchStmt(
                                                                new ArithExp('*', new VarExp("a"), new ValExp(new IntValue(10))),
                                                                new ArithExp('*', new VarExp("b"), new VarExp("c")),
                                                                new CompStmt(new PrintStmt(new VarExp("a")), new PrintStmt(new VarExp("b"))),
                                                                new ValExp(new IntValue(10)),
                                                                new CompStmt(new PrintStmt(new ValExp(new IntValue(100))), new PrintStmt(new ValExp(new IntValue(200)))),
                                                                new PrintStmt(new ValExp(new IntValue(300)))
                                                        ), new PrintStmt(new ValExp(new IntValue(300))))))))));
        allStmts.add(exSwitch);

        //REPEAT UNTIL STATEMENT
        IStmt exRepUntil = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValExp(new IntValue(0))),
                        new CompStmt(new RepeatUntilStmt(
                                new CompStmt(new ForkStmt(new CompStmt(new PrintStmt(new VarExp("v")),
                                        new AssignStmt("v", new ArithExp('-', new VarExp("v"), new ValExp(new IntValue(1)))))),
                                        new AssignStmt("v", new ArithExp('+', new VarExp("v"), new ValExp(new IntValue(1))))),
                                new RelExp("==", new VarExp("v"), new ValExp(new IntValue(3)))
                        ),
                                new CompStmt(new VarDeclStmt("x", new IntType()),
                                        new CompStmt(new VarDeclStmt("y", new IntType()),
                                                new CompStmt(new VarDeclStmt("z", new IntType()),
                                                        new CompStmt(new VarDeclStmt("w", new IntType()),
                                                                new CompStmt(new AssignStmt("x", new ValExp(new IntValue(1))),
                                                                        new CompStmt(new AssignStmt("y", new ValExp(new IntValue(2))),
                                                                                new CompStmt(new AssignStmt("z", new ValExp(new IntValue(3))),
                                                                                        new CompStmt(new AssignStmt("w", new ValExp(new IntValue(4))),
                                                                                                new PrintStmt(new ArithExp('*', new VarExp("v"), new ValExp(new IntValue(10)))))))))))))));
        allStmts.add(exRepUntil);
        //CONDITIONAL ASSIGNMENT
        IStmt exCondAssign = new CompStmt(new VarDeclStmt("b", new BoolType()),
                new CompStmt(new VarDeclStmt("c", new IntType()),
                        new CompStmt(new AssignStmt("b", new ValExp(new BoolValue(true))),
                                new CompStmt(new CondAssignStmt("c",
                                        new VarExp("b"),
                                        new ValExp(new IntValue(100)),
                                        new ValExp(new IntValue(200))),
                                        new CompStmt(new PrintStmt(new VarExp("c")),
                                                new CompStmt(new CondAssignStmt("c",
                                                        new ValExp(new BoolValue(false)),
                                                        new ValExp(new IntValue(100)),
                                                        new ValExp(new IntValue(200))),
                                                        new PrintStmt(new VarExp("c"))))))));
        allStmts.add(exCondAssign);

        //MUL EXPRESSION
        IStmt exMul = new CompStmt(new VarDeclStmt("v1", new IntType()),
                new CompStmt(new VarDeclStmt("v2", new IntType()),
                        new CompStmt(new AssignStmt("v1", new ValExp(new IntValue(2))),
                                new CompStmt(new AssignStmt("v2", new ValExp(new IntValue(3))),
                                        new IfStmt(new RelExp("!=", new VarExp("v1"), new ValExp(new IntValue(0))),
                                                new PrintStmt(new MulExExp(new VarExp("v1"), new VarExp("v2"))),
                                                new PrintStmt(new VarExp("v1")))))));
        allStmts.add(exMul);

        //DO WHILE STATEMENT
        IStmt exDoWhile = new CompStmt(new VarDeclStmt("v", new IntType()),
                new CompStmt(new AssignStmt("v", new ValExp(new IntValue(4))),
                        new CompStmt(new DoWhileStmt(new RelExp(">", new VarExp("v"), new ValExp(new IntValue(0))),
                                new CompStmt(new PrintStmt(new VarExp("v")), new AssignStmt("v",new ArithExp('-', new VarExp("v"), new ValExp(new IntValue(1)))))),
                                new PrintStmt(new VarExp("v")))));
        allStmts.add(exDoWhile);


        return FXCollections.observableArrayList(allStmts);
    }

}
