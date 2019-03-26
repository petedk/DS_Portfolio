// import libraries
import java.util.*;
import java.io.*;


public class GlobalRunner{
	// define class vars
	private static ArrayList<String> fname = new ArrayList<>();
	private static int i = 0;
	private static TreeMap<String, TreeMap<String, ArrayList<Integer>>> fullWordMap = new TreeMap<>();

// Methods used by worker threads
	public synchronized static void updateTreeMap(String fn, TreeMap<String, ArrayList<Integer>> wm){
		fname.add(fn.substring(0,fn.length()-4));
		fullWordMap.put(fname.get(i),wm);
		i++;
	}	// end updateTreeMap


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

// end of Methods used by worker threads

	public static void main(String args[]) throws Exception {
		// start timer
		Long start = System.currentTimeMillis();
		// define main vars
		String inputFile = args[0];
		String outputFile = args[1];
		int wordsPerPage = Integer.parseInt(args[2]);
		String basePath = new File("").getAbsolutePath();
		File inputFilePath = new File(basePath + "/" + inputFile + "/");
		File outputFilePath = new File(basePath + "/" + outputFile + "/");
		ArrayList<String> outputString = new ArrayList<>();
		String[] files = inputFilePath.list();
		int numThreads = files.length;
		// System.out.println("Number of threads: " + numThreads);
		int workerCount = 0;
		GlobalThread[] theWorkers = new GlobalThread[numThreads]; 
		// check if output file exists & create it if not
		if(!outputFilePath.exists()){
			outputFilePath.mkdir();
		} // end of checking if file exists
		// get file list
		for (String file : files){
			// pass path, file, wordsPerPage to thread
			theWorkers[workerCount] = new GlobalThread(inputFilePath, file, wordsPerPage);
			theWorkers[workerCount].start();
			workerCount++;
		} // end for file list	
		for(GlobalThread it : theWorkers){
			try{
				if(it.isAlive()){
					it.join();
				}// end if alive
			} catch(Exception e){
				System.out.println("Something went wrong with a worker thread");
			} // end try catch 
		} // end waiting for threads to finish
		// get output string array
		outputString = createOutputString();
		// save output string array
		saveOutput(outputString, outputFilePath, "output.txt");
		// end timer
		Long end = System.currentTimeMillis();
		// print total time
		System.out.println("Total wall clock time to run the program was " + (end - start) + " milliseconds."); 
	} // end main


	public static ArrayList<String> createOutputString()  throws Exception{
		ArrayList<String> outputString = new ArrayList<>();
		outputString.add("Word, ");
		// Get all keys
		Set<String> allKeys =  getAllKeys();
		// System.out.println("List of keys is " + allKeys.size() + " elements long.");
		// order file names
		Collections.sort(fname);
		// System.out.println("Assending fname sort: " + fname);
		// build first line of output
		String firstLine = "";
		for (String each : fname){
			 firstLine += each + ", ";
		}
		outputString.add(firstLine.substring(0,firstLine.length()-2) + "\n");
		// System.out.println("Print first line of output: " + outputString);
		// loop through each in allKeys
		for (String k : allKeys){
			outputString.add(formatThisLine(k) + "\n");
		} // end allKeys loop
		// return output
		return outputString;
		// System.out.println(outputString);
	} // end createOutputString


	public static Set<String> getAllKeys(){
		Set<String> allKeys = new TreeSet<>();
		TreeMap<String, ArrayList<Integer>> temp = new TreeMap<>();
		// System.out.println("Printing from printFName");
		for (String each : fname){
			// System.out.println("File names: " + each);
			temp = fullWordMap.get(each);
			for (String e : temp.keySet()) {
   				// System.out.println(e);
   				allKeys.add(e);
   			}	
		}		
		return allKeys;
	} // end getAllKeys



	public static String formatThisLine(String k){
		TreeMap<String, ArrayList<Integer>> temp = new TreeMap<>();
		ArrayList<Integer> values = new ArrayList<>();
		String line = k + ", ";
		// loop through each tree for this key and add to string
		for (String each : fname){
			// System.out.println("Print file: " + each);
			temp = fullWordMap.get(each);
			if(temp.containsKey(k)){
				values = temp.get(k);
				// System.out.println("Values: " + values);
				for (int v : values){
					line += String.valueOf(v) + ":";
				} // end for values
				line = line.substring(0,line.length()-1) + ", "; 
			} else {
				line += ", "; 
			} // end if key in map
		} // end for each treeMap
		return line;
	} // end formatLine


	public static void saveOutput(ArrayList<String> wordlist, File outputFilePath, String file) throws Exception {
		Iterator<String> iter = wordlist.iterator();
		String fname = file.substring(0,file.length()-4); 
		PrintWriter output = new PrintWriter(new FileWriter(outputFilePath + "/" + file));
		while(iter.hasNext()){
		output.print(iter.next()+" ");
		}
		//Close the file to ensure all values are printed.
		output.close();
	} // end  saveoutput

} // end class GlobalRunner