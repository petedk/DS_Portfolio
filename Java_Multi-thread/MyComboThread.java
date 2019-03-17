import java.util.*;

public class MyComboThread extends Thread{

    private int currentSize;
    private int numberThreads;
    private HashMap<Integer, ArrayList<Integer>> data;
    private HashSet<Integer> allInterests;
    
    public MyComboThread(int c, HashMap<Integer, ArrayList<Integer>> d, int n, HashSet<Integer> all){
        currentSize = c;
        data = d;
        numberThreads = n;
        allInterests = all;
    }
    
    public void checkCombinations(ArrayList<Integer> curSolution, int start, int end, int elementsLeft){
        if(RunnerCombos.bestKnown() > currentSize){
            //check and see if we already know of a better solution.
            //if our potential solution is smaller than what we already know, then check it. else, stop.
            if(elementsLeft==0){
                //combination that we are checking is in curSolution
                HashSet<Integer> currentCheck = new HashSet<>();
                for(Integer curPerson : curSolution){
                    //get interests for current person
                    ArrayList<Integer> interests = data.get(curPerson);
                    for(Integer interest : interests){
                        currentCheck.add(interest);
                    }
                }
                //if currentCheck==allInterests, we are done, tell the runner and quit
                if(currentCheck.size() == allInterests.size()){
                    String answer = "";
                    for(Integer person : curSolution){
                        answer += person + " ";
                    }
                    RunnerCombos.setBest(answer, curSolution.size());
                    System.out.println("Found answer: "+answer+" of size "+currentSize+".");
                }
            } else{
                //more stuff to check, loop through all at end
                for(int i = start; i < end; i++){
                    ArrayList<Integer> newPrefix = new ArrayList<>(curSolution);
                    newPrefix.add(i);
                    checkCombinations(newPrefix, i+1, end, elementsLeft-1);
                }
            }
        } else{
            //nothing left to check, so stop thread
            try{System.out.println("Stopped "+currentSize);Thread.currentThread().stop();}catch(Exception e){}
        }
    }
    
    public void run(){
        while(RunnerCombos.bestKnown() > currentSize){
            System.out.println("Started "+currentSize);
            checkCombinations(new ArrayList<Integer>(), 0, data.size(), currentSize);
            System.out.println("Finished "+currentSize);
            currentSize += numberThreads;
        }
    }
}