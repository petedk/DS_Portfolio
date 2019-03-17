import java.util.*;
import java.io.*;

public class MyStayThread extends Thread{
	
	//Create any variables that are being passed from the Runner to the thread. These variables will be used in the run method below.

	private long numSimulations;
	
	//Create a constructor to match what the Runner is sending. 

	public MyStayThread(long n){
		numSimulations = n;
	} // end constructor
	
	public void run(){
		long wins = 0;
		// create random class
		Random rnd = new Random();
		for (int i = 0; i< numSimulations ; i++ ) {
			// need random num generator (1 to 3)
			int right_door = rnd.nextInt(3) + 1;
			// sleep for 1 millisecond
			try{
				Thread.currentThread().sleep(1);
			}catch(Exception e){}
			// have random num pick guess (1 to 3)
			int guess_door = rnd.nextInt(3) + 1;
			// check if win:
			if(right_door == guess_door){ 
				wins++;
			} // end if doors equal
		} // end for i loop
		//Once finished, tell the Runner thread how many winners there were.
		//Once finished, tell the Runner thread how many winners there were.
		RunnerP2.addStayWinner(wins);
	} // end run
}// end class Tread