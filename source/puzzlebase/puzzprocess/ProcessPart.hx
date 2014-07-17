package puzzlebase.puzzprocess;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class ProcessPart extends FlxGroup
{
	public var complete:Bool = false;

	public function new() 
	{
		super();
	}
	
	public function begin():Void
	{
		
	}
	
	public function launch():Void
	{
		complete = false;
	}
	
	private function onFinalComplete(t:FlxTween = null):Void
	{
		complete = true;
		Reg.puzzleMain.rules.nextMove();
	}
	
	public function flush():Void
	{
		
	}
	
}