package repository;

import exception.MyException;
import model.PrgState;
import java.util.List;
import java.io.IOException;
public interface IRepository {
    List<PrgState> getProgramList();
    void setProgramStates(List<PrgState> programStates);
    //PrgState getCurrentPrg();
    void add(PrgState e);
    void logPrgStateExec(PrgState programState) throws IOException, MyException;
    void emptyLogFile() throws IOException;

}
