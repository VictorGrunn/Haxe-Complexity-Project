package puzzlebase.combatgame.player;
import flixel.FlxSprite;

/**
 * ...
 * @author Victor Grunn
 */
class PlayerTemplate extends FlxSprite
{
	public var maxHP:Int;
	public var currentHP:Int;
	
	public var basicAttackDamage:Int;

	public function new() 
	{
		super();
	}
	
	public function takeDamage(_amount:Int):Void
	{
		currentHP -= _amount;
		
		if (currentHP < 0)
		{
			currentHP = 0;
		}
	}
	
	public function countDownRound():Void
	{
		
	}
	
}