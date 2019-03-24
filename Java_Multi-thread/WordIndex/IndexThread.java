import java.util.*;
import java.io.*;

public class IndexThread extends Thread{
	String basePath = new File("").getAbsolutePath();
	private File inputFilepath = new File(basePath);
	private File outputFilePath = new File(basePath);
	private String filename;
	private int wordsPerPage;
	private TreeMap<String, ArrayList<Integer>> wordMap = new TreeMap<>();
	private int lettersOnThisPage = 0;
	private int pageNumber = 1;
	private String word = "";
	private ArrayList<String> wordlist = new ArrayList<>();

	// public IndexThread(Path p, String f, int wpp){
	public IndexThread(File ifp, File ofp, String f, int wpp){
		inputFilepath = ifp;
		outputFilePath = ofp;
		filename = f;
		wordsPerPage = wpp;
	} // end constructor

	public void run(){
		// open up file from input file and read out words
		try{
			Scanner input = new Scanner(new File(inputFilepath + "/" + filename));
			ArrayList<String> words = new ArrayList<>();
			while(input.hasNext()){
				String temp = input.next();
				word = temp.toLowerCase();
				// count words to determine page numbers
				lettersOnThisPage += word.length();
				if(lettersOnThisPage > wordsPerPage){
					// track pages
					pageNumber ++;
					lettersOnThisPage = word.length();
				} // end if new page
				// add word to TreeMap
				wordMap = IndexRunner.addvalue(wordMap, word, pageNumber);				
			} // end while
			// format results:
			wordlist = IndexRunner.formatOutput(wordMap);
			// save results:
			IndexRunner.saveOutput(wordlist, outputFilePath, filename);
		} catch(Exception e){
			System.out.println("Something went wrong with a worker thread");
		}

	} // end run

} // end class IndexThread

