package a7.interpreterwithgui.gui;

import a7.interpreterwithgui.controller.Controller;
import a7.interpreterwithgui.exception.MyException;
import a7.interpreterwithgui.model.PrgState;
import a7.interpreterwithgui.model.adt.MyIDictionary;
import a7.interpreterwithgui.model.adt.MyIHeap;
import a7.interpreterwithgui.model.stmts.IStmt;
import a7.interpreterwithgui.model.value.Value;
import javafx.beans.property.SimpleIntegerProperty;
import javafx.beans.property.SimpleStringProperty;
import javafx.collections.FXCollections;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.scene.control.*;
import javafx.scene.input.MouseEvent;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;


public class PrgExecutorController {
    private Controller controller;

    @FXML
    private TextField TextViewNoOfPrgState;

    @FXML
    private TableView<Pair<Integer, Value>> HeapTableTableView;

    @FXML
    private TableColumn<Pair<Integer,Value>,Integer> AddressColumn;

    @FXML
    private TableColumn<Pair<Integer,Value>,String> ValueColumn;

    @FXML
    private ListView<String> OutListView;

    @FXML
    private ListView<String> FileTableListView;

    @FXML
    private ListView<String> PrgStatesIdsListView;

    @FXML
    private TableView<Pair<String,Value>> SymbolTableTableView;

    @FXML
    private TableColumn<Pair<String,Value>,String> VarNameColumn;

    @FXML
    private TableColumn<Pair<String,Value>,String> VarValueColumn;

    @FXML
    private ListView<String> ExeStackListView;


    public void setController(Controller controller) {
        this.controller = controller;
        populate();
    }

    @FXML
    public void initialize()
    {
        PrgStatesIdsListView.getSelectionModel().setSelectionMode(SelectionMode.SINGLE);

        AddressColumn.setCellValueFactory(p-> new SimpleIntegerProperty(p.getValue().first).asObject());
        ValueColumn.setCellValueFactory(p->new SimpleStringProperty(p.getValue().second.toString()));
        VarNameColumn.setCellValueFactory(p->new SimpleStringProperty(p.getValue().first));
        VarValueColumn.setCellValueFactory((p->new SimpleStringProperty(p.getValue().second.toString())));
    }

    private PrgState getCurrentPrgState()
    {
        if(controller.getPrgStates().size() ==0)
            return null;
        else
        {
            int currentId = PrgStatesIdsListView.getSelectionModel().getSelectedIndex();
            if(currentId == -1)
                return controller.getPrgStates().get(0);
            else
                return controller.getPrgStates().get(currentId);
        }
    }

    private void populate()
    {
        populateHeapTableTableView();
        populateOutListView();
        populateFileTableListView();
        populatePrgStatesIdsListView();
        populateSymTableView();
        populateExeStackListView();

    }

    @FXML
    private void changeProgramState(MouseEvent event) {
        populateExeStackListView();
        populateSymTableView();
    }

    private void populateTextViewNoOfPrgState() {
        List<PrgState> programStates = controller.getPrgStates();
        TextViewNoOfPrgState.setText(String.valueOf(programStates.size()));
    }

    private void populateHeapTableTableView() {
        PrgState programState = getCurrentPrgState();
        MyIHeap heap = Objects.requireNonNull(programState).getHeap();
        ArrayList<Pair<Integer, Value>> heapEntries = new ArrayList<>();
        for(Map.Entry<Integer, Value> entry: heap.getContent().entrySet()) {
            heapEntries.add(new Pair<>(entry.getKey(), entry.getValue()));
        }
        HeapTableTableView.setItems(FXCollections.observableArrayList(heapEntries));
    }

    private void populateOutListView() {
        PrgState programState = getCurrentPrgState();
        List<String> output = new ArrayList<>();
        List<Value> outputList = Objects.requireNonNull(programState).getOut().getList();
        int index;
        for (index = 0; index < outputList.size(); index++){
            output.add(outputList.get(index).toString());
        }
        OutListView.setItems(FXCollections.observableArrayList(output));
    }

    private void populateFileTableListView() {
        PrgState programState = getCurrentPrgState();
        List<String> files = new ArrayList<>(Objects.requireNonNull(programState).getFileTable().getContent().keySet());
        FileTableListView.setItems(FXCollections.observableList(files));
    }

    private void populatePrgStatesIdsListView() {
        List<PrgState> programStates = controller.getPrgStates();
        List<Integer> idList = programStates.stream().map(PrgState::getId).collect(Collectors.toList());
        PrgStatesIdsListView.setItems(FXCollections.observableList(Collections.singletonList(idList.toString())));
        populateTextViewNoOfPrgState();
    }

    private void populateSymTableView() {
        PrgState programState = getCurrentPrgState();
        MyIDictionary<String, Value> symbolTable = Objects.requireNonNull(programState).getSymTable();
        ArrayList<Pair<String, Value>> symbolTableEntries = new ArrayList<>();
        for (Map.Entry<String, Value> entry: symbolTable.getContent().entrySet()) {
            symbolTableEntries.add(new Pair<>(entry.getKey(), entry.getValue()));
        }
        SymbolTableTableView.setItems(FXCollections.observableArrayList(symbolTableEntries));
    }

    private void populateExeStackListView() {
        PrgState programState = getCurrentPrgState();
        List<String> executionStackToString = new ArrayList<>();
        if (programState != null)
            for (IStmt statement: programState.getExeStack().getReversed()) {
                executionStackToString.add(statement.toString());
            }
        ExeStackListView.setItems(FXCollections.observableList(executionStackToString));
    }

    @FXML
    private void runOneStep(ActionEvent mouseEvent) {
        if (controller != null) {
            try {
                List<PrgState> programStates = Objects.requireNonNull(controller.getPrgStates());
                if (programStates.size() > 0) {
                    controller.oneStepForAllPrograms(programStates);
                    populate();
                    programStates = controller.removeCompletedPrg(controller.getPrgStates());
                    controller.setPrgStates(programStates);
                    populatePrgStatesIdsListView();
                } else {
                    Alert alert = new Alert(Alert.AlertType.ERROR);
                    alert.setTitle("Error!");
                    alert.setHeaderText("An error has occured!");
                    alert.setContentText("There is nothing left to execute!");
                    alert.showAndWait();
                }
            } catch (ExecutionException|InterruptedException| IOException| MyException e) {
                Alert alert = new Alert(Alert.AlertType.ERROR);
                alert.setTitle("Execution error!");
                alert.setHeaderText("An execution error has occured!");
                alert.setContentText(e.getMessage());
                alert.showAndWait();
            }
        } else {
            Alert alert = new Alert(Alert.AlertType.ERROR);
            alert.setTitle("Error!");
            alert.setHeaderText("An error has occured!");
            alert.setContentText("No program selected!");
            alert.showAndWait();
        }
    }
}


