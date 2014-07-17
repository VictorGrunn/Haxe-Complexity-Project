package puzzlebase.combatgame.orders;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class MonsterAttackOrder extends OrderTemplate
{
	private var attackAmount:Int;

	public function new(_damageAmount:Int) 
	{
		super();
		
		attackAmount = _damageAmount;
		
		trace(Reg.puzzleMain.monster + " attacked for " + attackAmount + " damage!");
	}
	
	override public function begin():Void
	{
		super.begin();
		
		Reg.puzzleMain.fightScreen.player.takeDamage(attackAmount);
		
		var targetRatio:Float = Reg.puzzleMain.fightScreen.player.currentHP / Reg.puzzleMain.fightScreen.player.maxHP;		
		
		var tween:FlxTween = FlxTween.multiVar(Reg.puzzleMain.fightScreen.playerHP.HPBar.scale, { x: targetRatio }, .25, { complete: onFinalComplete } );
	}
	
}