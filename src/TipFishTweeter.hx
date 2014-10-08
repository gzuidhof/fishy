package ;

import twitter4j.TwitterFactory;
import twitter4j.Twitter;
import twitter4j.Status;
import twitter4j.StatusUpdate;

using StringTools;


/**
 * Tweets the latest post
 * @author Guido
 */
class TipFishTweeter
{

	private var postFolder:String;
	
	public function new(postFolder:String) 
	{
		this.postFolder = postFolder;
	}
	
	public function tweetLastPost()
	{
		var latestPostNumber = HugoContentReader.getHighestPostNumber(postFolder);
		if (latestPostNumber == null)
		{
			throw "Unable to find latest postnumber, post folder is empty?";
		}
		
		trace ("Latest post number: " + latestPostNumber);
		var hReader = new HugoContentReader();
		hReader.readFile(postFolder + "/" + latestPostNumber + ".md");
		hReader.parse();
		
		var titleToTweet: String = hReader.getTomlValue("title");
		
		//Remove " at the ends of the string, if they are present.
		if (titleToTweet.startsWith("\""))
		{
			titleToTweet = titleToTweet.substr(1);
		}
		if (titleToTweet.endsWith("\""))
		{
			titleToTweet = titleToTweet.substr(0, titleToTweet.length-1);
		}
		
		trace ("Title to tweet: " + titleToTweet);
		
		var linkToTweet:String = "http://gamedev.tip.fish/post/" + latestPostNumber + "/";
		
		trace ("Link to tweet: " + linkToTweet);
		
		var statusUpdateText: String = titleToTweet + " " + linkToTweet;
		
		try //Tweet it!
		{
			var twitter: Twitter = TwitterFactory.getSingleton();
			var su: StatusUpdate = new StatusUpdate(statusUpdateText);
			var status: Status = twitter.updateStatus(su);
			
			trace ("Tweeted! \"" + status.getText() + "\"");
		}
		catch (e: Dynamic) //Gotta catch 'em all
		{
			trace ("Something went wrong tweeting\n" + e.toString());
		}
	}
}