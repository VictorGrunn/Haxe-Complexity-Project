package puzzlebase.combatgame.monsters;
import flixel.FlxSprite;
import puzzlebase.puzzprocess.combatmoves.encounters.monsters.RemoveMonsterProcess;

/**
 * ...
 * @author Victor Grunn
 */
class MonsterTemplate extends FlxSprite
{
	private var maxHP:Int;
	public var currentHP:Int;
	private var living:Bool = true;
	
	private var attackDamage:Int;
	
	private var maxRoundsUntilAttack:Int;	
	private var roundsLeft:Int;	
	
	public var name:String;

	public function new() 
	{
		super();
	}
	
	public function countdownRound():Void
	{
		roundsLeft -= 1;					
		
		if (currentHP <= 0)
		{
			trace("This ran.");
			var removeProcess:RemoveMonsterProcess = new RemoveMonsterProcess();
			Reg.puzzleMain.rules.resolveRoundProcess.addEnemyMove(removeProcess);
			return;
		}
		
		if (roundsLeft <= 0)
		{
			roundsLeft = maxRoundsUntilAttack;
			roundEvent();
		}
	}
	
	public function launch():Void
	{
		currentHP = maxHP;
		roundsLeft = maxRoundsUntilAttack;
	}
	
	public function takeDamage(_amount:Int):Void
	{
		currentHP -= _amount;
		
		if (currentHP < 0)
		{
			currentHP = 0;
		}
	}
	
	public function roundEvent():Void
	{
		
	}
	
}