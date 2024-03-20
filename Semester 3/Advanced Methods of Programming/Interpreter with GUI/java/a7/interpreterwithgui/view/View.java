package a7.interpreterwithgui.view;

import a7.interpreterwithgui.controller.Controller;
import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.*;
import a7.interpreterwithgui.model.expression.ArithExp;
import a7.interpreterwithgui.model.expression.LogicExp;
import a7.interpreterwithgui.model.expression.ValExp;
import a7.interpreterwithgui.model.expression.VarExp;
import a7.interpreterwithgui.model.stmts.*;
import a7.interpreterwithgui.model.type.BoolType;
import a7.interpreterwithgui.model.type.IntType;
import a7.interpreterwithgui.model.value.BoolValue;
import a7.interpreterwithgui.model.value.IntValue;
import a7.interpreterwithgui.model.value.Value;
import a7.interpreterwithgui.repository.IRepository;
import a7.interpreterwithgui.repository.Repository;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Objects;
import java.util.Scanner;
import java.util.concurrent.ExecutionException;

public class View {

    public void start() {
        boolean done = false;
        while (!done) {
           // try {
                //showMenu();
                Scanner readOption = new Scanner(System.in);
                int option = readOption.nextInt();
                if (option == 0) {
                    done = true;
                } else if (option == 1) {
                    //runProgram1();
                } else if (option == 2) {
                    //runProgram2();
                } else if (option == 3) {
                   // runProgram3();
                }else if (option == 4){
                    //runProgram4();
                }
                else {
                    System.out.println("Invalid input!");
                }
            } //catch (MyException e) {
                //System.out.println(e.getMessage());
            }
            //catch (InputMismatchException e)
            {
              //  System.out.println("Please put an integer");
            }
       // }
   // }
    private void showMenu() {
        System.out.println("MENU: ");
        System.out.println("0. Exit.");
        System.out.println("1. Run the first program: \n\tint v;\n\tv=2;\n\tPrint(v)");
        System.out.println("2. Run the second program: \n\tint a;\n\tint b;\n\ta=2+3*5;\n\tb=a+1;\n\tPrint(b)");
        System.out.println("3. Run the third program: \n\tbool a;\n\tint v;\n\ta=true;\n\t(If a Then v=2 Else v=3);\n\tPrint(v)");
        System.out.println("4. Run the fourth program: \n\tint v;\n\tv=2;\n\tPrint(true & false)");
        System.out.println("Choose an option: ");
    }
    private void runProgram1() throws MyException, IOException, ExecutionException, InterruptedException {
        IStmt example1 = new CompStmt(new VarDeclStmt("v",new IntType()),
                new CompStmt(new AssignStmt("v",new ValExp(new IntValue(2))), new PrintStmt(new
                        VarExp("v"))));
        runStatement(example1);
    }
    private void runProgram2() throws MyException, IOException, ExecutionException, InterruptedException {
        IStmt example2=  new CompStmt( new VarDeclStmt("a",new IntType()),
                new CompStmt(new VarDeclStmt("b",new IntType()),
                        new CompStmt(new AssignStmt("a", new ArithExp('+',new ValExp(new IntValue(2)),new
                                ArithExp('*',new ValExp(new IntValue(3)), new ValExp(new IntValue(5))))),
                                new CompStmt(new AssignStmt("b",new ArithExp('+',new VarExp("a"), new ValExp(new
                                        IntValue(1)))), new PrintStmt(new VarExp("b"))))));
        runStatement(example2);
    }

    private void runProgram3() throws MyException, IOException, ExecutionException, InterruptedException {
        IStmt example3=  new CompStmt(new VarDeclStmt("a",new BoolType()),
                new CompStmt(new VarDeclStmt("v", new IntType()),
                        new CompStmt(new AssignStmt("a", new ValExp(new BoolValue(true))),
                                new CompStmt(new IfStmt(new VarExp("a"),new AssignStmt("v",new ValExp(new
                                        IntValue(2))), new AssignStmt("v", new ValExp(new IntValue(3)))), new PrintStmt(new
                                        VarExp("v"))))));
        runStatement(example3);
    }

    private void runProgram4() throws MyException, IOException, ExecutionException, InterruptedException {
        IStmt example4 = new CompStmt(new VarDeclStmt("v",new IntType()),
                new CompStmt(new AssignStmt("v",new ValExp(new IntValue(2))),
                        new PrintStmt(new LogicExp('&',new ValExp(new BoolValue(true)),new ValExp(new BoolValue(false))))));
        runStatement(example4);
    }

    public void runStatement(IStmt stmt) throws MyException,IOException,InterruptedException, ExecutionException {
        MyIStack<IStmt> execStack = new MyStack<IStmt>();
        MyIDictionary<String, Value> symtbl = new MyDictionary<String,Value>();
        MyIList<Value> out = new MyList<Value>();
        MyIDictionary<String,BufferedReader> fileTable = new MyDictionary<>();
        MyIHeap heap = new MyHeap();

        PrgState crtPrgState = new PrgState(execStack,symtbl,out,fileTable,heap, stmt);
        IRepository repo = new Repository(crtPrgState,"log.txt");
        Controller controller = new Controller(repo);

        System.out.println("Do you want to display the steps?[Y/n]");
        Scanner readOption = new Scanner(System.in);
        String option = readOption.next();
        controller.setDisplayFlag(Objects.equals(option, "Y"));
        try {
            controller.allStep();
        }catch(MyException | IOException e){
            System.out.println(e.getMessage());
        }
        System.out.println("Result: " + crtPrgState.getOut().toString());

    }
}
