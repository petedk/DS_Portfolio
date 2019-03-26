import java.util.*;
import java.io.*;

public class GlobalThread extends Thread{
	String basePath = new File("").getAbsolutePath();
	private File inputFilepath = new File(basePath);
	private String filename;
	private int wordsPerPage;
	private TreeMap<String, ArrayList<Integer>> wordMap = new TreeMap<>();
	private int lettersOnThisPage = 0;
	private int pageNumber = 1;
	private String word = "";
	private ArrayList<String> wordlist = new ArrayList<>();


	public GlobalThread(File ifp, String f, int wpp){
		inputFilepath = ifp;
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

			GlobalRunner.updateTreeMap(filename, wordMap);
	} catch(Exception e){
		System.out.println("Something went wrong with a worker thread");
	}
	} // end run

} // end class IndexThread

