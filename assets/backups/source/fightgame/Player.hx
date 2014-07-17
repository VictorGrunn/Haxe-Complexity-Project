package fightgame;
import flixel.FlxSprite;

/**
 * ...
 * @author Victor Grunn
 */
class Player extends FlxSprite
{

	public function new() 
	{
		super();
		
		makeGraphic(50, 50);
		health = 50;
	}
	
}