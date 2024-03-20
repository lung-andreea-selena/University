package a7.interpreterwithgui.controller;

import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.value.RefValue;
import a7.interpreterwithgui.model.value.Value;
import a7.interpreterwithgui.repository.IRepository;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Controller {
    IRepository repo;
    boolean displayFlag=false;
    ExecutorService executorService;

    public Controller(IRepository repo)
    {
        this.repo = repo;
        executorService = Executors.newFixedThreadPool(2);
    }

    Map<Integer,Value> unsafeGarbageCollector(List<Integer> symTblAddr,Map<Integer,Value> heap)
    {
        return heap.entrySet().stream()
                .filter(e->symTblAddr.contains(e.getKey()))
                .collect(Collectors.toMap(Map.Entry::getKey,Map.Entry::getValue));
    }
    Map<Integer,Value> safeGarbageCollector(List<Integer> symTblAddr,List<Integer> heapAddr,Map<Integer,Value> heap)
    {
        return heap.entrySet().stream()
                .filter(e->symTblAddr.contains(e.getKey()) || heapAddr.contains(e.getKey()))
                .collect(Collectors.toMap(Map.Entry::getKey,Map.Entry::getValue));
    }

    List<Integer> getAddrFromSymTable(Collection<Value> symTableValues) {
        return symTableValues.stream()
                .filter(v->v instanceof RefValue)
                .map(v->{RefValue v1=(RefValue) v;return v1.getAddress();})
                .collect(Collectors.toList());
    }


    public PrgState oneStepForAllPrograms(List<PrgState> prgList) throws ExecutionException,InterruptedException,IOException,MyException
    {
        prgList.forEach(prgState ->
        {
            try{
                this.repo.logPrgStateExec(prgState);
                display(prgState);
            }catch (IOException | MyException e){
                System.out.println("\u001B[31m" + e.getMessage() + "\u001B[0m");
            }
        });
        List<Callable<PrgState>> callList = prgList.stream()
                .map((PrgState p) ->(Callable<PrgState>)(p::oneStep))
                .collect(Collectors.toList());

        List<PrgState> newProgramList = executorService.invokeAll(callList).stream().map(future->
        {
            try{
                return future.get();
            }catch(ExecutionException | InterruptedException e){
                System.out.println("\u001B[31m" + e.getMessage() + "\u001B[0m");
            }
            return null;
        }).filter(Objects::nonNull).collect(Collectors.toList());

        prgList.addAll(newProgramList);
        conservativeGarbageCollector(prgList);
        prgList.forEach(prgState ->
        {
            try{
                repo.logPrgStateExec(prgState);
                display(prgState);
            }catch(IOException | MyException e)
            {
                System.out.println("\u001B[31m" + e.getMessage() + "\u001B[0m");
            }
        });
        repo.setProgramStates(prgList);
        return null;
    }
    public void allStep() throws MyException,IOException,InterruptedException,ExecutionException
    {

        List<PrgState> prgStates = removeCompletedPrg(repo.getProgramList());
        while(!prgStates.isEmpty())
        {
            oneStepForAllPrograms(prgStates);
            prgStates = removeCompletedPrg(repo.getProgramList());
        }
        executorService.shutdownNow();
        repo.setProgramStates(prgStates);
    }


    public void conservativeGarbageCollector(List<PrgState> programStates) {
        List<Integer> symTableAddresses = Objects.requireNonNull(programStates.stream()
                        .map(p -> getAddrFromSymTable(p.getSymTable().values()))
                        .map(Collection::stream)
                        .reduce(Stream::concat).orElse(null))
                .collect(Collectors.toList());
            programStates.get(0).getHeap().setContent((HashMap<Integer, Value>) safeGarbageCollector(symTableAddresses, getAddrFromHeap(programStates.get(0).getHeap().getContent().values()), programStates.get(0).getHeap().getContent()));

    }

    public List<Integer> getAddrFromHeap(Collection<Value> heapValues) {
        return heapValues.stream()
                .filter(v -> v instanceof RefValue)
                .map(v -> {RefValue v1 = (RefValue) v; return v1.getAddress();})
                .collect(Collectors.toList());
    }

    public void setDisplayFlag(boolean value) {
        this.displayFlag = value;
    }

    private void display(PrgState prgState)
    {
        if(displayFlag)
            System.out.println(prgState.toString());
    }

    public List<PrgState> removeCompletedPrg(List<PrgState> inPrgList)
    {
        return inPrgList.stream().filter(p->!p.isNotCompleted()).collect(Collectors.toList());
    }

    public List<PrgState> getPrgStates()
    {
        return this.repo.getProgramList();
    }
    public void setPrgStates(List<PrgState> prgstates)
    {
        this.repo.setProgramStates(prgstates);
    }
}
