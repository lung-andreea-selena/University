import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class HamiltonianCycleSearchTask implements Runnable{

    private final List<List<Integer>> graph;
    private final int startingNode;
    private final AtomicBoolean foundHamiltonianCycle; //atomic boolean shared across threads to stop others if a cycle is found
    private final List<Integer> possiblePath;
    private final List<Integer> output;
    private final Lock lock;
    private final List<Boolean> visited;

    public HamiltonianCycleSearchTask(List<List<Integer>> graph, int startingNode, AtomicBoolean foundHamiltonianCycle, List<Integer> output){
        this.graph = graph;
        this.startingNode = startingNode;
        this.foundHamiltonianCycle = foundHamiltonianCycle;
        this.possiblePath = new ArrayList<>();
        this.output = output;
        this.lock = new ReentrantLock();
        this.visited = new ArrayList<>();
        for (int i = 0; i < this.graph.size(); i++) {
            this.visited.add(false);
        }
    }

    private void foundCycle(){
        this.possiblePath.add(this.startingNode);
        this.foundHamiltonianCycle.set(true);
        this.lock.lock(); //we lock to ensure that only one thread has access to output list
        this.output.clear();
        this.output.addAll(this.possiblePath);
        this.lock.unlock();
    }

    private void goToNode(int nextNode){ //recursive function to explore paths from nextNode
        if(foundHamiltonianCycle.get()){
            return;
        }

        this.possiblePath.add(nextNode);
        this.visited.set(nextNode, true);

        //base case - when we found a solution
        if(this.possiblePath.size() == this.graph.size()){
            if(this.graph.get(nextNode).contains(this.startingNode)){ //the current node has a direct edge back to the startingNode.
                this.foundCycle();
            }
        }
        else { //recursive
            for(Integer outboundNeighbour: this.graph.get(nextNode)){ //loops through all neighbours of the node we are at
                if(!this.visited.get(outboundNeighbour)){ //if the neighbour was not visited it recursively goes with the neighbour
                    this.goToNode(outboundNeighbour);
                    return; //ensure only one path is explored at a time for this thread
                }
            }
        }
    }

    @Override
    public void run() {
        this.goToNode(this.startingNode);
    }
}