public class MyPiRunner{
	public static double totalInCircle = 0;
	public synchronized static void addCircle(){ // this allows the threads to talk back to the runner and synchronously increment the totalInCircle var
		totalInCircle++;
		// System.out.println("Total In Circle: " + totalInCircle);
	};


	public static void main(String args[]) throws Exception  {
		int numPoints = Integer.parseInt(args[0]);
		int numThreads = Integer.parseInt(args[1]);
		MyPi[] theWorkers = new MyPi[numThreads];
		for (int i = 0; i< numThreads ;i++ ) {
			theWorkers[i] = new MyPi(numPoints);
			theWorkers[i].start();
		} // end for i
		for(MyPi mp : theWorkers){
			if(mp.isAlive()){
				mp.join(); // wait for mp to finish
				// totalInCircle += mp.getNumberInCircle(); not getting this from the threads.. get this from the method addCircle
			} // end if is.Alive
		} // end for loop of theWorkers
		// System.out.println("Total In Circle: " + totalInCircle);
		double answer = 4 * totalInCircle / (numPoints * numThreads * 1);
		System.out.println("The answer: " + answer);
	} // end main
} // end class MyPiRunner