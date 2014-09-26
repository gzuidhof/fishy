package ;
import sys.FileSystem;
using StringTools;

/**
 * Checks whether all files in staging folder are valid.
 * 
 * Valid:
	 * Number file name
	 * Markdown extension
	 * TOML frontmatter
	 * draft:true in TOML
 * 
 * 
 * @author Guido
 */
class TipFishStageVerifier
{
	/**
	 * Path to folder containing staged posts.
	 */
	var stageFolderPath: String;
	
	/**
	 * All tests were succesful after verify
	 */
	var allSuccess: Bool;
	
	public function new(stageFolderPath: String) 
	{
		this.stageFolderPath = stageFolderPath;
	}
	
	public function verify(exitAfter:Bool): Bool
	{
		var files = FileSystem.readDirectory(stageFolderPath);
		allSuccess = true;
		Sys.println ("Verifying stage folder, path " + stageFolderPath);
		
		for (filename in files)
		{
			Sys.print("Verifying " + filename);
			
			if (filename.startsWith(".") || FileSystem.isDirectory(stageFolderPath + "/" + filename))
			{
				Sys.print(" - valid\n");
				continue;
			}
			
			if (!filename.endsWith(".md"))
			{
				allSuccess = false;
				trace("Wrong file extension!");
				continue;
			}
			
			var number: Null<Int>;
			number = Std.parseInt(filename.replace(".md", ""));
			
			if (number == null)
			{
				allSuccess = false;
				trace("Wrong filename! Must be a number");
				continue;
			}
			
			var reader = new HugoContentReader();
			reader.readFile(stageFolderPath + "/" + filename);
			
			if (!reader.verifyIsHugoContent())
			{
				allSuccess = false;
				trace("File is not a hugo TOML file!");
				continue;
			}
			
			reader.parse();
			if (reader.getTomlvalue("draft") != "true")
			{
				allSuccess = false;
				trace("File should be a draft!");
				continue;
			}
			Sys.print(" - valid\n");
		}
		
		if (exitAfter)
			Sys.exit(allSuccess? 0:1);
			
		return allSuccess;
	}
	
	
	
	
}