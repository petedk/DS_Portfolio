import java.util.*;

public class RunnerP2{

	//Declare any variables here that you need to aggregate any information that is sent back from the threads. 
	private static long stayWins = 0L;
	private static Long switchWins = 0L;

	public synchronized static void addStayWinner (Long wins){
		stayWins += wins;
	}

	public synchronized static void addSwitchingWinner (Long wins){
		switchWins += wins;
	}


	public static void main(String args[])  throws Exception {
		//Start your timing here.
		long start = System.currentTimeMillis();
		Long n = Long.parseLong(args[0]);
		System.out.println("n: " + n);
		//Since we have 8 cores on our EC2 instance, it is reasonable to split up the work 8 ways. 
		int numWorkers = 8;
		MyStayThread[] workers = new MyStayThread[numWorkers];

		for(int i=0; i<numWorkers; i++){
			//Create a new thread and start it.
			workers[i] = new MyStayThread(n/numWorkers); 
			workers[i].start();
		}  // end creating all workers
		
		//Make sure the workers are finished before the Runner finishes.
		for(int i=0; i<numWorkers ; i++){
			//If the worker thread is already done, this will just continue on to the next thread.
			try{
				workers[i].join();
			} catch(Exception e){
				System.out.println("Something went wrong with worker thread "+i+".");
			}
		} // end checking that all workers have completed thier work


		MySwitchingThread[] workers2 = new MySwitchingThread[numWorkers];

		for(int i=0; i<numWorkers; i++){
			//Create a new thread and start it.
			workers2[i] = new MySwitchingThread(n/numWorkers); 
			workers2[i].start();
		} // end creating all workers
		
		//Make sure the workers are finished before the Runner finishes.
		for(int i=0; i<numWorkers; i++){
			//If the worker thread is already done, this will just continue on to the next thread.
			try{
				workers2[i].join();
			} catch(Exception e){
				System.out.println("Something went wrong with worker thread "+i+".");
			}
		} // end checking that all workers have completed thier work

		//All threads are finished working, now do something with the answer. Maybe print it out?
		//System.out.println("Best integer was " + someInteger + " and it was from " + someString);	


		// System.out.println("Worker from MyStayThread: " + (stayWins* 1.0));
		// System.out.println("Worker from MySwitchThread: " + (switchWins*1.0));

		System.out.println(((double)(stayWins)/(double)(n) * 100) + " % win rate when user does NOT switch doors.");
		System.out.println(((double)(switchWins)/(double)(n) * 100) + " % win rate when user switches doors.");

		//Print out how long it took.
		long stop = System.currentTimeMillis();
		Double time_delta = ((stop - start) / 1000.0);
		System.out.println("Total wall clock elapsed time "+ time_delta + " seconds.");
	}
}