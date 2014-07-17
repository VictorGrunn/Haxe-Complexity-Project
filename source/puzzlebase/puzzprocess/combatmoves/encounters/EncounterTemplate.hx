package puzzlebase.puzzprocess.combatmoves.encounters;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class EncounterTemplate extends FlxGroup
{
	public var complete:Bool = false;
	public var started:Bool = false;

	public function new() 
	{
		super();
	}
	
	public function begin():Void
	{
		started = true;
	}
	
	public function onFinalComplete(t:FlxTween = null):Void
	{
		complete = true;
	}	
}