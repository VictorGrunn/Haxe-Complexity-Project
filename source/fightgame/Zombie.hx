package fightgame;
import flixel.FlxSprite;

/**
 * ...
 * @author Victor Grunn
 */
class Zombie extends FlxSprite
{

	public function new() 
	{
		super();
		makeGraphic(50, 50, 0xff00ff00);		
		health = 20;
	}
	
}