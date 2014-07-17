package puzzlebase.puzzprocess;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class ProcessPart
{
	public var complete:Bool = false;

	public function new() 
	{
		
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
	
}