package view;
import controller.Controller;
import exception.MyException;
import model.adt.MyHeap;
import model.expression.*;
import model.PrgState;
import model.stmts.*;
import model.type.*;
import model.adt.MyDictionary;
import model.adt.MyList;
import model.adt.MyStack;
import model.value.BoolValue;
import model.value.IntValue;
import model.value.StringValue;
import repository.IRepository;
import repository.Repository;

import javax.management.ValueExp;
import java.io.IOException;
public class Interpreter {
    public static void main(String[] args)
    {   TextMenu menu = new TextMenu();
        IStmt example1 = new CompStmt(new VarDeclStmt("v",new IntType()),
                new CompStmt(new AssignStmt("v",new ValExp(new IntValue(2))), new PrintStmt(new
                        VarExp("v"))));
        try{example1.typeCheck(new MyDictionary<>());
            PrgState prg1=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),example1);
            IRepository repo1 = new Repository(prg1,"log1.txt");
            Controller controller1=new Controller(repo1);
            menu.addCommand(new RunExampleCommand("2", example1.toString(), controller1));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }

        IStmt example2=  new CompStmt( new VarDeclStmt("a",new IntType()),
                new CompStmt(new VarDeclStmt("b",new IntType()),
                        new CompStmt(new AssignStmt("a", new ArithExp('+',new ValExp(new IntValue(2)),new
                                ArithExp('*',new ValExp(new IntValue(3)), new ValExp(new IntValue(5))))),
                                new CompStmt(new AssignStmt("b",new ArithExp('+',new VarExp("a"), new ValExp(new
                                        IntValue(1)))), new PrintStmt(new VarExp("b"))))));
        try{example2.typeCheck(new MyDictionary<>());
            PrgState prg2=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),example2);
            IRepository repo2 = new Repository(prg2,"log2.txt");
            Controller controller2=new Controller(repo2);
            menu.addCommand(new RunExampleCommand("2", example2.toString(), controller2));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }

        IStmt example3=  new CompStmt(new VarDeclStmt("a",new BoolType()),
                new CompStmt(new VarDeclStmt("v", new IntType()),
                        new CompStmt(new AssignStmt("a", new ValExp(new BoolValue(true))),
                                new CompStmt(new IfStmt(new VarExp("a"),new AssignStmt("v",new ValExp(new
                                        IntValue(2))), new AssignStmt("v", new ValExp(new IntValue(3)))), new PrintStmt(new
                                        VarExp("v"))))));
        try{example3.typeCheck(new MyDictionary<>());
            PrgState prg3=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),example3);
            IRepository repo3 = new Repository(prg3,"log3.txt");
            Controller controller3=new Controller(repo3);
            menu.addCommand(new RunExampleCommand("3", example3.toString(), controller3));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }

        IStmt example4 = new CompStmt(new VarDeclStmt("varf", new StringType()),
                new CompStmt(new AssignStmt("varf", new ValExp(new StringValue("test.in"))),
                        new CompStmt(new OpenReadFile(new VarExp("varf")),
                                new CompStmt(new VarDeclStmt("varc", new IntType()),
                                        new CompStmt(new ReadFile(new VarExp("varf"), "varc"),
                                                new CompStmt(new PrintStmt(new VarExp("varc")),
                                                        new CompStmt(new ReadFile(new VarExp("varf"), "varc"),
                                                                new CompStmt(new PrintStmt(new VarExp("varc")),
                                                                        new CloseReadFile(new VarExp("varf"))))))))));

        try{example4.typeCheck(new MyDictionary<>());
            PrgState prg4=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),example4);
            IRepository repo4 = new Repository(prg4,"log4.txt");
            Controller controller4=new Controller(repo4);
            menu.addCommand(new RunExampleCommand("4", example4.toString(), controller4));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }


        IStmt example5 = new CompStmt(new VarDeclStmt("a", new IntType()),
                new CompStmt(new VarDeclStmt("b", new IntType()),
                        new CompStmt(new AssignStmt("a", new ValExp(new IntValue(5))),
                                new CompStmt(new AssignStmt("b", new ValExp(new IntValue(7))),
                                        new IfStmt(new RelExp(">", new VarExp("a"),
                                                new VarExp("b")),new PrintStmt(new VarExp("a")),
                                                new PrintStmt(new VarExp("b")))))));
        try{example5.typeCheck(new MyDictionary<>());
            PrgState prg5=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),example5);
            IRepository repo5 = new Repository(prg5,"log5.txt");
            Controller controller5=new Controller(repo5);
            menu.addCommand(new RunExampleCommand("5", example5.toString(), controller5));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }


        IStmt ex6 = new CompStmt(new VarDeclStmt("v",new RefType(new IntType())),new CompStmt(new NewStmt("v",new ValExp(new IntValue(20))),
            new CompStmt(new VarDeclStmt("a",new RefType(new RefType(new IntType()))),new CompStmt(
                    new NewStmt("a",new VarExp("v")),new CompStmt(new PrintStmt(new VarExp("v")),
                    new PrintStmt(new VarExp("a")))))));
        try{ex6.typeCheck(new MyDictionary<>());
            PrgState prg6=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),ex6);
            IRepository repo6 = new Repository(prg6,"log6.txt");
            Controller controller6=new Controller(repo6);
            menu.addCommand(new RunExampleCommand("6", ex6.toString(),controller6));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }

        IStmt ex7= new CompStmt(
                new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(new NewStmt("v", new ValExp(new IntValue(20))),
                        new CompStmt(new VarDeclStmt("a", new RefType(new RefType(new IntType()))),
                                new CompStmt(new NewStmt("a", new VarExp("v")),
                                        new CompStmt(new NewStmt("v", new ValExp(new IntValue(30))),
                                                new PrintStmt(new ReadHeapExpression(new ReadHeapExpression(new VarExp("a")))))))));
        try{ex7.typeCheck(new MyDictionary<>());
            PrgState prg7=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),ex7);
            IRepository repo7 = new Repository(prg7,"log7.txt");
            Controller controller7=new Controller(repo7);
            menu.addCommand(new RunExampleCommand("7", ex7.toString(),controller7));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }


        IStmt ex8= new CompStmt(
                new VarDeclStmt("v", new RefType(new IntType())),
                new CompStmt(
                        new NewStmt("v", new ValExp(new IntValue(20))),
                        new CompStmt(
                                new NewStmt("v", new ValExp(new IntValue(30))),
                                new PrintStmt(new ReadHeapExpression(new VarExp("v"))))));
        try{ex8.typeCheck(new MyDictionary<>());
            PrgState prg8=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),ex8);
            IRepository repo8 = new Repository(prg8,"log8.txt");
            Controller controller8=new Controller(repo8);
            menu.addCommand(new RunExampleCommand("8", ex8.toString(),controller8));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }


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
        try{exFork.typeCheck(new MyDictionary<>());
            PrgState prgFork=new PrgState(new MyStack<>(),new MyDictionary<>(),new MyList<>(),new MyDictionary<>(),new MyHeap(),exFork);
            IRepository repoFork = new Repository(prgFork,"logFork.txt");
            Controller controllerFork=new Controller(repoFork);
            menu.addCommand(new RunExampleCommand("9", exFork.toString(),controllerFork));
        }catch (MyException e)
        {
            System.out.println(e.getMessage());
        }

        menu.addCommand(new ExitCommand("0", "exit"));
        menu.show();
    }

}
