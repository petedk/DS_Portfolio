import java.util.*;

public class First{

	public static void main(String[] args) {
		int num1 = getPositiveValue();
		int num2 = getPositiveValue();
		printPrime(num1, num2);
	} // end main

	public static int getPositiveValue(){
		Scanner input = new Scanner(System.in);
		System.out.print("Enter number: ");
		int value = input.nextInt();
		//ensure the value read in is non-negative
		while(value < 0){
			System.out.print("Enter in a positive number: ");
			value = input.nextInt();
		} // end while value < 0
		return value;
	} // end getPositiveValue

	public static void printPrime(int first, int second){
		int[] values = Ordered(first,second);
		int num1 = values[0];
		int num2 = values[1]; 
		String result = "";
		if(num1 < 2){
			num1 = 2;
		} // end if num less than 2
		for (int i = num1 + 1; i < num2 ; i++) {
			if(isPrime(i)){
				result += i + " ";
			} // end if
		} // end for loop
		if(result.length() == 0){
			System.out.println("No primes.");
		} else{
			System.out.println(result.substring(0,result.length()-1));
		} // end if length = 0
	} // end printPrime

	public static int[] Ordered(int num1, int num2){
		int[] results = new int[2];
		if(num1 < num2){
			results[0] = num1;
			results[1] = num2;
		} else {
			results[0] = num2;
			results[1] = num1;
		}
		return results;
	} // end Ordered


	public static boolean isPrime(int value){
		boolean prime = true;
		for (int i = value-1; i > 1 ; i -- ) {
			if( value % i == 0 ){
				prime = false;
			} // end if
		} // end for loop
		return prime;
	} // end isPrime

} // end of class First