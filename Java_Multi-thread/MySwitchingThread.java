import java.util.*;
import java.io.*;

public class MySwitchingThread extends Thread{
	
	private long numSimulations;
	
	public MySwitchingThread(long n){
		numSimulations = n;
	}
	
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
			// change guess
			for (int j = 1;j < 4 ;j++ ) {
				if(!(guess_door == j || right_door == j)){
					// System.out.println("Open Door: " + j);
					guess_door = 6 - guess_door - j;
					j = 4;
				} // end if
			} // end for j loop
			// check if win:
			if(right_door == guess_door){ 
				wins++;
			} // end if doors equal
		} // end for i loop
		//Once finished, tell the Runner thread how many winners there were.
		RunnerP2.addSwitchingWinner(wins);
	} // end run
}// end class Tread