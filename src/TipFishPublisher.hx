package ;
import sys.FileSystem;
using StringTools;

/**
 * Moves a file from stage folder to publish folder.
 */
class TipFishPublisher
{
	
	private var stageFolder:String;
	private var postFolder:String;
	
	public function new(stageFolder:String, postFolder:String) 
	{
		this.stageFolder = stageFolder;
		this.postFolder = postFolder;
	}
	
	public function publishFromStage()
	{
		Sys.println("Stage folder: " + stageFolder);
		Sys.println("Post folder: " + postFolder);
		var stagedPostNrToPublish = HugoContentReader.getLowestPostNumber(stageFolder);
		var postNrToPublish = HugoContentReader.getHighestPostNumber(postFolder) + 1;
		
		if (stagedPostNrToPublish == null)
			throw "No staged post to publish";
			
		
		Sys.println("Preparing to publish staged post #" + stagedPostNrToPublish + " as post " + postNrToPublish);
		
		var hReader = new HugoContentReader();
		hReader.readFile(stageFolder + "/" + stagedPostNrToPublish + ".md");
		hReader.parse();
		hReader.setTomlValue("draft", false);
		
		var now = Date.now();
		
		//"2014-09-22T02:51:01+00:00" (doesn't take into account timezone offset from UTC)
		var dateString:String = ("\"" + now.toString().replace(" ", "T") + "+00:00\"");
		
		hReader.setTomlValue("date", dateString);
		hReader.writeToFile(postFolder + "/" + postNrToPublish + ".md");
		
		Sys.println("Removing staged post");
		FileSystem.deleteFile(stageFolder + "/" + stagedPostNrToPublish + ".md");
		
	}
	
	
	
}