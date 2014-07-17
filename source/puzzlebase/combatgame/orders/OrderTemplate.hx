package puzzlebase.combatgame.orders;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class OrderTemplate extends FlxGroup
{
	public var complete:Bool = false;

	public function new() 
	{
		super();
	}
	
	public function begin():Void
	{
		
	}
	
	public function onFinalComplete(t:FlxTween = null)
	{
		complete = true;
		Reg.puzzleMain.fightScreen.nextMove();
	}
	
}