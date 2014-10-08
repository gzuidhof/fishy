package ;

import haxetoml.TomlParser;

/**
 * Command line tool for tip.fish.
 * @author Guido
 */

class Fishy 
{	
	static function main() 
	{
		Sys.println("fishy, cwd: " + Sys.getCwd());
		var fishy = new Fishy();
	}
	
	public var options = {
		stageFolderPath : "content/_stage",
		postFolderpath: "content/post"
	}
	
	
	public function new() {
		
		var args = Sys.args();
		if (args.length == 0)
		{
			Sys.println("Add an argument!");
			printHelp();
		}
		else if (args[0] == "verify")
		{
			verify();
		}
		else if (args[0] == "publish")
		{
			publish();
		}
		else if (args[0] == "tweet")
		{
			tweet();
		}
		else {
			printHelp();
		}
		
	};
	
	private function verify()
	{
		var verifier = new TipFishStageVerifier(options.stageFolderPath);
		verifier.verify(true);
	}
	
	private function publish()
	{
		trace("Starting publish");
		var publisher = new TipFishPublisher(options.stageFolderPath, options.postFolderpath);
		publisher.publishFromStage();
	}
	
	private function tweet()
	{
		var twatter = new TipFishTweeter(options.postFolderpath);
		twatter.tweetLastPost();
	}
	
	
	
	private function printHelp()
	{
		Sys.println("Possible arguments: verify, help, publish, tweet");
		Sys.println("tweet not yet implemented");
	}
	
	
	
	
	
}