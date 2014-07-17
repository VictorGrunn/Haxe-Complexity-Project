package source;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.loaders.TexturePackerData;
import puzzlebase.combatgame.monsters.MonsterTemplate;
import flixel.text.FlxText;

/**
 * ...
 * @author Victor Grunn
 */
class AssetsRegistry
{
	public static var initialized:Bool = false;
	
	public static var redStamp:FlxSprite;
	public static var blueStamp:FlxSprite;
	public static var greenStamp:FlxSprite;
	public static var yellowStamp:FlxSprite;
	public static var blackStamp:FlxSprite;
	public static var purpleStamp:FlxSprite;		
	
	public static var ballsSprites:TexturePackerData;
	
	public static var pieceSize:Int = 30;
	
	public static var masterTextGroup:FlxTypedGroup<FlxText>;
	
	public static var masterMonsterGroup:FlxTypedGroup<MonsterTemplate>;
	
	public static var masterSpriteGroup:FlxTypedGroup<FlxSprite>;

	public function new() 
	{
		
	}
	
	public static function init():Void
	{
		if (initialized == true)
		{
			return;
		}
		
		initialized = true;
		
		redStamp = new FlxSprite();		
		redStamp.makeGraphic(pieceSize - 4, pieceSize - 4, 0xffff0000);
		
		blueStamp = new FlxSprite();
		blueStamp.makeGraphic(pieceSize - 4, pieceSize - 4, 0xff0000ff);
		
		greenStamp = new FlxSprite();
		greenStamp.makeGraphic(pieceSize - 4, pieceSize - 4, 0xff00ff00);
		
		yellowStamp = new FlxSprite();
		yellowStamp.makeGraphic(pieceSize - 4, pieceSize - 4, 0xffffff00);
				
		blackStamp = new FlxSprite();
		blackStamp.makeGraphic(pieceSize - 4, pieceSize - 4, 0xff222222);
		
		purpleStamp = new FlxSprite();		
		purpleStamp.makeGraphic(pieceSize - 4, pieceSize - 4, 0xffcc00ff);
		
		ballsSprites = new TexturePackerData("assets/images/balls.json", "assets/images/balls.png");		
		
		masterTextGroup = new FlxTypedGroup<FlxText>();
		
		masterMonsterGroup = new FlxTypedGroup<MonsterTemplate>();
		
		masterSpriteGroup = new FlxTypedGroup<FlxSprite>();
	}
	
	public static function giveNewText():FlxText
	{
		var t:FlxText = masterTextGroup.recycle(FlxText, [0, 0, 400]);
		t.exists = true;
		if (t == null)
		{
			throw "For some reason, it was null.";
		}
		return t;
	}
	
	public static function giveNewSprite():FlxSprite
	{
		var t:FlxSprite = masterSpriteGroup.recycle(FlxSprite);
		t.exists = true;
		return t;
	}
	
}