package ;

import haxetoml.TomlParser;
import java.Lib;

/**
 * ...
 * @author Guido
 */

class Fishy 
{
	public function new(){};
	
	static function main() 
	{
		Sys.println("fishy, cwd: " + Sys.getCwd());

		trace(Date.now().toString());
		
		new Fishy().debug();
	}
	
	private function debug()
	{
		var h = new HugoContentReader();
		h.readFile("../test/testpost.md");
		h.verifyIsHugoContent();
		h.parse();
		trace(h.toString());
		
		h.setTomlValue("draft", "false");
		trace(h.toString());
		trace (h.frontMatter);
		
		h.writeToFile("testoutput.md");
	}
	
}