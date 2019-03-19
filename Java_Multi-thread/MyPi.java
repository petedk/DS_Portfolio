public class MyPi extends Thread{ 
	private int numPoints, numCircle; // numPoints total number of points generated, numCircle: number of points in the circle
	public MyPi(int numPoints){
		this.numPoints = numPoints;
	} // end MyPi

	public void run(){
		int count = 0;
		while(count < numPoints){
			double x = Math.random();
			double y = Math.random();
			if(containedInCircle(x,y)){
				MyPiRunner.addCircle(); // MyPiRunner will keep track off all points in all threads
				// System.out.println("Add one");
				// numCircle++;
			} // end if
			count++;
		} // end while
	} // end run

	public boolean containedInCircle(double x, double y){
		return Math.sqrt(Math.pow(x - 0.5, 2) + Math.pow(y - 0.5, 2)) <= .5;
	} // end containedInCircle

	public int getNumberInCircle(){
		return numCircle;
	} // end getNumberInCircle
} // end MyPi class