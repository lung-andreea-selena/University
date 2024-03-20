package a7.interpreterwithgui.repository;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.LinkedList;
import java.util.List;
public class Repository implements IRepository {
    private List<PrgState> repo;
    private int currentPos;
    private final String logFilePath;
    public Repository(PrgState progState,String logFilePath)
    {
        this.logFilePath=logFilePath;
        this.repo = new LinkedList<PrgState>();
        this.currentPos = 0;
        this.add(progState);
    }

    public int getCurrentPos()
    {
        return currentPos;
    }

    public void setCurrentPos(int currentP)
    {
        this.currentPos=currentP;
    }
    @Override
    public List<PrgState> getProgramList()
    {
        return this.repo;
    }

    @Override
    public void setProgramStates(List<PrgState> progS)
    {
        this.repo=progS;
    }
    @Override
    public void add(PrgState e)
    {
        repo.add(e);
    }


    @Override
    public String toString()
    {
        return "Repository{" + "repo=" + repo + '}';
    }

    @Override
    public void logPrgStateExec(PrgState programState) throws IOException, MyException
    {
        PrintWriter logFile;
        logFile= new PrintWriter(new BufferedWriter(new FileWriter(logFilePath,true)));
        logFile.println(programState.toString());
        logFile.close();
    }
    @Override
    public void emptyLogFile() throws IOException
    {
        PrintWriter logFile;
        logFile=new PrintWriter(new BufferedWriter(new FileWriter(logFilePath,false)));
        logFile.close();
    }


}
