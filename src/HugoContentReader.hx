package ;
import haxetoml.TomlParser;
import sys.FileSystem;
import sys.io.File;
import sys.io.FileInput;

using StringTools;

/**
 * Reads a hugo content file. Hugo content files consist of two parts, the frontmatter and the content, 
 * divided by +++ or --- depending on the frontmatter syntax (TOML or YAML). This reader currently 
 * only supports TOML.
 * @author Guido
 */
@:keep
class HugoContentReader
{
	
	/**
	 * All lines in file.
	 */
	private var lines: Array<String>;
	
	/**
	 * Lines that make up the frontmatter
	 */
	public var frontLines: Array<String>;
	
	/**
	 * Lines that make up the content
	 */
	public var contentLines: Array<String>; 
	
	/**
	 * Read-only frontmatter dynamic object.
	 */
	public var frontMatter: Dynamic;
	
	
	public function new() 
	{
		
	}
	
	/**
	 * Reads given file into memory.
	 * @param	filePath
	 */
	public function readFile(filePath: String)
	{
		if (!FileSystem.exists(filePath))
		{
			throw "File \"" + filePath +"\" is non-existent.";
		}
		
		var fileInput: FileInput = File.read(filePath);
		
		lines= new Array<String>();
		
		while (!fileInput.eof())
		{
			lines.push(fileInput.readLine());
		}
		fileInput.close();
	}
	
	/**
	 * Verify that read file is a TOML hugo content file.
	 */
	public function verifyIsHugoContent(): Bool
	{
		if (lines == null)
		{
			trace( "No file read yet, use HugoContentReader.read first");
			return false;
		}
		
		//First line must be "+++" if TOML is used.
		if (!(lines[0] == "+++"))
			return false;
		
		var plusCount: Int = 0;
		//Must contain another "+++" (the end of the frontmatter).
		for (s in lines)
		{
			if (s == "+++")
				plusCount++;
		}
		
		if (plusCount < 2)
			return false;
			
		return true;
	}
	
	public function parse()
	{
		//Remove the first +++, starting the frontmatter.
		lines.remove("+++");
		
		var index = lines.indexOf("+++");
		
		frontLines = new Array<String>();
		Lambda.foreach(lines, function(x) {
			frontLines.push(x);
			return true;
		});
		
		
		contentLines = frontLines.splice(index, lines.length - index);
		
		//Remove the +++ indicating the start of contentlines
		contentLines.remove("+++");
		
		parseTomlLines();
	}
	
	private function parseTomlLines()
	{
		//Parse toml into dynamic format
		var front: String = "";
		
		Lambda.foreach(frontLines, function(x) {
			front += frontLines + "\n";
			return true;
		});
		
		frontMatter = TomlParser.parseString(front, {});
	}
	
	public function setTomlValue(key:String, value:Dynamic)
	{
		var from:String = Lambda.find(frontLines, function(s)
		{
			return s.trim().startsWith(key);
		});
		
		frontLines[frontLines.indexOf(from)] = (key + " = " + value);
		parseTomlLines();
	}
	
	public function getTomlValue(key:String)
	{
		var string:String = Lambda.find(frontLines, function(s)
		{
			return s.trim().startsWith(key);
		});
		
		return string.split("=")[1].trim();
	}
	
	
	
	public function writeToFile(filePath: String)
	{
		if (lines == null || frontLines == null)
			throw "Can't write without having loaded parsed file into memory!";
		
		var writer = File.write(filePath);

		writer.writeString("+++\n");
		
		Lambda.foreach(frontLines, function(s) {
			writer.writeString(s+"\n");
			return true;
		});
		
		writer.writeString("+++\n");
		Lambda.foreach(contentLines, function(s) {
			writer.writeString(s+"\n");
			return true;
		});
		
		writer.close();
	}
	
	public function toString(): String
	{
		return "Frontlines: " + frontLines.toString() + "\n" 
			+ "ContentLines: " + contentLines.toString();
	}
	
	public static function getHighestPostNumber(folderPath: String): Null<Int>
	{
		return getLowestOrHighestPostNumber(folderPath, true);
	}
	
	public static function getLowestPostNumber(folderPath: String): Null<Int>
	{
		return getLowestOrHighestPostNumber(folderPath, false);
	}
	
	private static function getLowestOrHighestPostNumber(folderPath:String, highest: Bool):Null<Int> 
	{
		var files = FileSystem.readDirectory(folderPath);
		var latest: Null<Int> = null;
		
		
		for(f in files)
		{
			var filename = folderPath + "/" + f;
			
			if (FileSystem.isDirectory(filename) || !filename.endsWith(".md"))
				continue;
				
			var fileNumber = Std.parseInt(filename.replace(folderPath+"/", "").replace(".md", ""));
			
			if (fileNumber == null)
				continue;
			else if (latest == null)
			{
				latest = fileNumber;
			}
			else if (highest && fileNumber > latest)
			{
				latest = fileNumber;
			}
			else if ((!highest) && fileNumber < latest)
			{
				latest = fileNumber;
			}
		}

		return latest;
		
	}
	
	
}