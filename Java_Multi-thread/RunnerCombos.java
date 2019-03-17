import java.util.*;
import java.io.*;

public class RunnerCombos{

    private static int bestSize = Integer.MAX_VALUE;
    private static String answer = "";
    
    //check if the newest best answer is better than what we already know
    public synchronized static void setBest(String possibleBest, int size){
        if(size < bestSize){
            bestSize = size;
            answer = possibleBest;
        }
    }
    
    //no need to synchronize because we are only retrieving a value, not changing it.
    public static int bestKnown(){
        return bestSize;
    }

    public static void main(String args[]) throws Exception{
        long start = System.currentTimeMillis();
        //read in file here
        HashMap<Integer, ArrayList<Integer>> data = new HashMap<>();
        HashSet<Integer> allInterests = new HashSet<>();
        Scanner s = new Scanner(new File("input.txt"));
        while(s.hasNextLine()){
            String firstLine = s.nextLine();
            String[] values = firstLine.split(" ");
            ArrayList<Integer> interests = new ArrayList<>(); //create a new ArrayList each time so each person has own list
            //skip first integer because it's the person's id
            for(int index = 1; index < values.length; index++){
                interests.add(Integer.parseInt(values[index]));
                allInterests.add(Integer.parseInt(values[index]));
            }
            data.put(Integer.parseInt(values[0]), interests);
        }
        
        //data contains a (key,value) pair with key being the person and value being all of the things the person likes
        
        //Since we have 8 cores on our EC2 instance, it is reasonable to split
        //up the work 8 ways to start. We will let thread 1 consider all possibilities
        //of size 1, thread 2 all possibilities of size 2 and so on.
        int numWorkers = 8;
        int currentSizeToConsider = 1;
        MyComboThread[] workers = new MyComboThread[numWorkers];
        for(int i=0; i<numWorkers; i++){
            workers[i] = new MyComboThread(currentSizeToConsider, data, 8, allInterests);  //add any arguments between ( )
            workers[i].start();
            currentSizeToConsider++;
        }
        
        for(int i=0; i<workers.length; i++){
            try{
                workers[i].join();
            } catch(Exception e){
                System.out.println("Something went wrong with worker thread "+i+".");
            }
        }

        System.out.println("Best answer was " + answer + ".");    

        //Print out how long it took.
        long stop = System.currentTimeMillis();
        Double time_delta = ((stop - start) / 1000.0);
        System.out.println("Total wall clock elapsed time "+ time_delta + " seconds.");
    }
}