package a7.interpreterwithgui.repository;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;

import java.io.IOException;
import java.util.List;
public interface IRepository {
    List<PrgState> getProgramList();
    void setProgramStates(List<PrgState> programStates);
    //PrgState getCurrentPrg();
    void add(PrgState e);
    void logPrgStateExec(PrgState programState) throws IOException, MyException;
    void emptyLogFile() throws IOException;

}
