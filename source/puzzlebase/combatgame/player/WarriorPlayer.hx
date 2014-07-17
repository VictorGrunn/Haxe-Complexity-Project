package puzzlebase.combatgame.player;
import flixel.FlxSprite;

/**
 * ...
 * @author Victor Grunn
 */
class WarriorPlayer extends PlayerTemplate
{
	public function new() 
	{
		super();		
		
		loadGraphic("assets/images/player/knight1.png");		
		
		maxHP = 25;
		currentHP = maxHP;
		
		basicAttackDamage = 1;
	}
	
}