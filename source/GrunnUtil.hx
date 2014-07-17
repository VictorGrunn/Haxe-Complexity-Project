package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

/**
 * ...
 * @author ...
 */
class GrunnUtil
{

	public function new() 
	{
		
	}
	
	public static function overlapCheck(t:FlxObject):Bool
	{
		var point:FlxPoint = FlxG.mouse.getScreenPosition();		
		
		if (point.x >= t.x && point.x <= t.x + t.width && point.y >= t.y && point.y <= t.y + t.height)
		{
			point = null;
			return true;
		}
		
		point = null;
		return false;
	}
	
	public static function randomArray(t:Array<Dynamic>):Dynamic
	{
		var arrayChoice:Dynamic = t[Math.floor(Math.random() * t.length)];
		return arrayChoice;
	}
	
}