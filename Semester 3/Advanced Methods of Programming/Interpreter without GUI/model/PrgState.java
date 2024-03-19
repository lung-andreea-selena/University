package model;

import exception.MyException;
import model.stmts.IStmt;
import model.adt.MyIStack;
import model.adt.MyIDictionary;
import model.adt.MyIList;
import model.value.Value;
import model.adt.MyIHeap;
import java.io.BufferedReader;
import java.util.List;

public class PrgState {
    MyIStack<IStmt> exeStack;
    MyIDictionary<String,Value> symTable;
    MyIList<Value> out;
    private MyIDictionary<String,BufferedReader> fileTable;
    private MyIHeap heap;
    IStmt originalProgram; //optional field, good to have
    private int id;
    private static int lastId=0;

    public PrgState(MyIStack<IStmt> stk, MyIDictionary<String,Value> symtbl,MyIList<Value> ot,MyIDictionary<String,BufferedReader> fileTable,MyIHeap heap,IStmt prg)
    {
        exeStack = stk;
        symTable = symtbl;
        out = ot;
        this.fileTable=fileTable;
        this.heap = heap;
        this.originalProgram = prg.deepCopy();
        this.exeStack.push(this.originalProgram);
        this.id=setId();
    }

    public PrgState(MyIStack<IStmt> stk, MyIDictionary<String,Value> symtbl,MyIList<Value> ot,MyIDictionary<String,BufferedReader> fileTable,MyIHeap heap)
    {
        exeStack = stk;
        symTable = symtbl;
        out = ot;
        this.fileTable=fileTable;
        this.heap = heap;
        this.id=setId();
    }
    public synchronized  int setId(){
        lastId++;
        return lastId;
    }

    public MyIStack<IStmt> getExeStack()
    {
        return exeStack;
    }

    public void setExeStack(MyIStack <IStmt> exeStack)
    {
        this.exeStack=exeStack;
    }

    public MyIDictionary<String,Value> getSymTable()
    {
        return symTable;
    }

    public void setSymTable(MyIDictionary<String,Value> symTable)
    {
        this.symTable = symTable;
    }

    public MyIList<Value> getOut()
    {
        return out;
    }

    public void setOut(MyIList<Value> out)
    {
        this.out= out;
    }

    public MyIDictionary<String,BufferedReader> getFileTable()
    {
        return fileTable;
    }
    public void setFileTable(MyIDictionary<String,BufferedReader>newFileTable)
    {
        this.fileTable=newFileTable;
    }

    public void setHeap(MyIHeap heap)
    {
        this.heap=heap;
    }
    public MyIHeap getHeap()
    {
        return this.heap;
    }
    public String printFileTable()
    {
        StringBuilder result = new StringBuilder();
        for(String s:this.fileTable.keyset())
        {
            result.append(s);
        }
        return result.toString();
    }

    public boolean isNotCompleted()
    {
        return exeStack.isEmpty();
    }

    public PrgState oneStep() throws MyException
    {
        if(exeStack.isEmpty())
            throw new MyException("Program state stack is empty!");
        IStmt currentStmt = exeStack.pop();
        return currentStmt.execute(this);
    }


    @Override
    public String toString()
    {
        return "Id: "+ id+"\n"+"ExeStack:\n"
                + exeStack.getReversed()+"\n" + "SymTable:\n"
                + symTable +"\n"+ "Out:\n" + out+"\n" +"FileTable:\n" + printFileTable() +"Heap memory:\n" +heap.toString()+"\n";
    }
}

