package overmap;
import flixel.FlxState;

/**
 * ...
 * @author Victor Grunn
 */
class MainMapState extends FlxState
{	
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		
		// Set a background color
		FlxG.cameras.bgColor = 0x00000000;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
	}
	
}