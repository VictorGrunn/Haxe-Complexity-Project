package puzzlebase.combatgame;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import puzzlebase.combatgame.player.PlayerTemplate;

/**
 * ...
 * @author Victor Grunn
 */
class PlayerHPBar extends FlxGroup
{
	public var HPBar:FlxSprite;
	
	private var player:PlayerTemplate;

	public function new(_visualTarget:FlxCamera, _trackTarget:PlayerTemplate, _offSet:Float = 1) 
	{
		super();
		
		HPBar = new FlxSprite();
		
		HPBar.makeGraphic(Std.int(_visualTarget.width * _offSet - 10), 10, 0xff00ff00);
		
		HPBar.x = _visualTarget.x + 5;
		HPBar.y = _visualTarget.y + (_visualTarget.height * _offSet);	
		
		HPBar.origin.x = 0;
		
		add(HPBar);
		
		player = _trackTarget;
	}
	
}