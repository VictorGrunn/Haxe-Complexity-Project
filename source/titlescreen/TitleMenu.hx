package titlescreen;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;

/**
 * ...
 * @author Victor Grunn
 */
class TitleMenu extends FlxGroup
{
	private var currentActive:TitlePiece;
	
	private var menuList:Array<FlxText>;
	
	private var pieceList:Array<TitlePiece>;
	
	private var activePiece:TitlePiece;
	
	public var alphaAll(default, set):Float = 1;

	public function new() 
	{
		super();						
	}
	
	public function set_alphaAll(t:Float):Float
	{
		setAll("alpha", t, true);
		return t;
	}
	
	public function loadButtons(_list:Array<TitlePiece>):Void
	{
		pieceList = new Array();		
		
		for (i in 0..._list.length)
		{
			pieceList.push(_list[i]);
			add(_list[i]);
		}		
		
		menuList = new Array();		
		
		for (i in 0...pieceList.length)
		{
			menuList.push(pieceList[i].optionText);			
		}
		
		for (i in 0...menuList.length)
		{						
			menuList[i].x = FlxG.width / 2 - menuList[i].width / 2;
			menuList[i].y = (menuList[i].height + 10) * i;
		}
	}
	
	public function processButton(t:TitlePiece):Void
	{
		if (activePiece == null)
		{
			remove(t);
			add(t);
			activePiece = t;
			t.begin();
			trace(t + " was processed.");
		}
	}
	
	public function endButton():Void
	{
		activePiece = null;
	}
	
	override public function destroy():Void 
	{
		super.destroy();
		
		for (i in 0...pieceList.length)
		{
			pieceList[i].destroy();
		}
		
		for (i in 0...menuList.length)
		{
			menuList[i].destroy();
		}
		
		activePiece = null;
	}
}