package puzzlebase.combatgame.monsters;
import flixel.util.FlxTimer;
import puzzlebase.combatgame.orders.MonsterAttackOrder;
import puzzlebase.puzzprocess.combatmoves.encounters.monsters.BasicMonsterAttack;

/**
 * ...
 * @author Victor Grunn
 */
class Goblin extends MonsterTemplate
{
	//private var attackTimer:FlxTimer;

	public function new() 
	{
		super();
		
		maxHP = 5;
		currentHP = maxHP;
		
		name = "Goblin";
		
		maxRoundsUntilAttack = 3;
		roundsLeft = maxRoundsUntilAttack;
		
		attackDamage = 1;
		
		loadGraphic("assets/images/monster/goblin1.png");
	}	
	
	override public function roundEvent():Void 
	{
		super.roundEvent();
		
		var newAttack:BasicMonsterAttack = new BasicMonsterAttack(attackDamage);
		trace(this + " is attacking for " + attackDamage + " damage!");
		Reg.puzzleMain.rules.resolveRoundProcess.addEnemyMove(newAttack);
	}
	
}