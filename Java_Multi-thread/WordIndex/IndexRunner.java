// import libraries
import java.util.*;
import java.io.*;


public class IndexRunner{
	// define class vars

	public static void main(String args[]) throws Exception   {
		// start timer
		Long start = System.currentTimeMillis();
		// define main vars
		String inputFile = args[0];
		String outputFile = args[1];
		int wordsPerPage = Integer.parseInt(args[2]);
		String basePath = new File("").getAbsolutePath();
		File inputFilePath = new File(basePath + "/" + inputFile + "/");
		File outputFilePath = new File(basePath + "/" + outputFile + "/");
		String[] files = inputFilePath.list();
		int numThreads = files.length;
		int workerCount = 0;
		IndexThread[] theWorkers = new IndexThread[numThreads]; 
		// check if output file exists & create it if not
		if(!outputFilePath.exists()){
			outputFilePath.mkdir();
		} // end of checking if file exists

		// get file list
		for (String file : files){
			// pass path, file, wordsPerPage to thread
			// theWorkers[workerCount] = new IndexThread(inputFilePath, file, wordsPerPage);
			theWorkers[workerCount] = new IndexThread(inputFilePath, outputFilePath, file, wordsPerPage);
			theWorkers[workerCount].start();
			workerCount++;
		} // end for file list	

		for(IndexThread it : theWorkers){
			try{
				if(it.isAlive()){
					it.join();
				}// end if alive
			} catch(Exception e){
				System.out.println("Something went wrong with a worker thread");
			} // end try catch 
		} // end waiting for threads to finish
		// end timer
		Long end = System.currentTimeMillis();
		// print total time
		System.out.println("Total wall clock time to run the program was " + (end - start) + " milliseconds."); 
	} // end main

	public static TreeMap<String,ArrayList<Integer>> addvalue(TreeMap<String, ArrayList<Integer>> wordMap, String word, Integer pageNumber){
		// check if word in is TreeMap
		if(wordMap.containsKey(word)){
			// get word list
			ArrayList<Integer> intList = new ArrayList<>();
			intList = wordMap.get(word);
			// check if page is there, add if needed
			if(!intList.contains(pageNumber)) {
				intList.add(pageNumber);
				wordMap.put(word,intList);
			}  // end if new page number
		} else {
			// add key and page
			ArrayList<Integer> intList = new ArrayList<>();
			intList.add(pageNumber);
			wordMap.put(word,intList);
		} // end if wordMap contains
		return wordMap;
	} // end add value to TreeMap

	public static ArrayList<String> formatOutput(TreeMap<String, ArrayList<Integer>> wordMap){
		ArrayList<String> wordlist = new ArrayList<>();
		for(Map.Entry<String,ArrayList<Integer>> entry : wordMap.entrySet()) {
			ArrayList<Integer> values = entry.getValue();
			String key = entry.getKey();
			String temp = "";
			for(int each : values){
				temp += String.valueOf(each) + ", ";
			}
			wordlist.add(key + " " + temp.substring(0, temp.length() - 2) + "\n");
		} // end loop for TreeMap
		return wordlist;
	} // end format output string

	public static void saveOutput(ArrayList<String> wordlist, File outputFilePath, String file) throws Exception {
		Iterator<String> iter = wordlist.iterator();
		String fname = file.substring(0,file.length()-4); 
		PrintWriter output = new PrintWriter(new FileWriter(outputFilePath + "/" + fname + "_output.txt"));
		while(iter.hasNext()){
		output.print(iter.next()+" ");
		}
		//Close the file to ensure all values are printed.
		output.close();
	} // end  saveoutput


} // end class IndexRunner