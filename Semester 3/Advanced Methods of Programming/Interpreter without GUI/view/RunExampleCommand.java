package view;
import controller.Controller;
import exception.MyException;
import java.io.IOException;
import java.util.Objects;
import java.util.Scanner;
import java.util.concurrent.ExecutionException;

public class RunExampleCommand extends Command{
    private final Controller controller;
    public RunExampleCommand(String key,String descr,Controller contrl)
    {
        super(key,descr);
        this.controller=contrl;
    }
    @Override
    public void execute()
    {
        try{
            System.out.println("Do you want to display all steps?[Y/n]");
            Scanner readOption = new Scanner(System.in);
            String option = readOption.next();
            controller.setDisplayFlag(Objects.equals(option,"Y"));
            controller.allStep();
        }catch (MyException | IOException exception)
        {
            System.out.println( exception.getMessage());
        } catch (ExecutionException e) {
            throw new RuntimeException(e);
        } catch (InterruptedException e) {
            System.out.println("\u001B[31m" + e.getMessage() + "\u001B[0m");
        }
    }
}
