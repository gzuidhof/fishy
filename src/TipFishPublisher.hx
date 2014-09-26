package ;
import sys.FileSystem;

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
		hReader.setTomlValue("date", ("\"" + now.getFullYear() + "-" + (now.getMonth() + 1) + "-" + now.getDate() + "\""));
		hReader.writeToFile(postFolder + "/" + postNrToPublish + ".md");
		
		Sys.println("Removing staged post");
		FileSystem.deleteFile(stageFolder + "/" + stagedPostNrToPublish + ".md");
		
	}
	
	
	
}