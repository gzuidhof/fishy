package ;

import haxetoml.TomlParser;

/**
 * Command line tool.
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
		stageFolderPath : "content/_stage"
	}
	
	
	public function new() {
		var args = Sys.args();
		if (args.length == 0)
		{
			printHelp();
		}
		else if (args[0] == "verify")
		{
			verify();
		}
		else {
			printHelp();
		}
		
	};
	
	
	private function debug()
	{
		var h = new HugoContentReader();
		h.readFile("../test/testpost.md");
		h.verifyIsHugoContent();
		h.parse();
		trace(h.toString());
		
		h.setTomlValue("draft", false);
		
		trace(h.toString());
		
		var dyn: Dynamic = h.frontMatter;
		trace(h.getTomlvalue("draft"));
		trace (h.frontMatter.draft);
		
		h.writeToFile("testoutput.md");
	}
	
	
	private function verify()
	{
		var verifier = new TipFishStageVerifier(options.stageFolderPath);
		verifier.verify(true);
	}
	
	private function printHelp()
	{
		Sys.println("Add an argument!");
			Sys.println("Possible arguments: verify, help, publish, tweet");
			Sys.println("publish and tweet not yet implemented");
	}
	
	
}