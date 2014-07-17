package puzzlebase.puzzprocess.combatmoves.playermoves;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class BasicPlayerAttack extends PlayerMoveTemplate
{
	private var attackAmount:Int;
	private var announceText:FlxText;

	public function new(_amount:Int) 
	{
		super();
		
		attackAmount = _amount;
		
		announceText = AssetsRegistry.giveNewText();
		announceText.alpha = 0;
		announceText.text = "Player has attacked for " + attackAmount + " damage!";
		announceText.setFormat(null, 14, 0xffffff, "center");
		FlxSpriteUtil.screenCenter(announceText, true, true);
	}
	
	private function onMessageRemoved(t:FlxTween):Void
	{
		onFinalComplete();
	}
	
	override public function begin():Void 
	{
		super.begin();
		
		Reg.puzzleMain.monster.takeDamage(attackAmount);
		
		trace("You attacked for " + attackAmount + " damage!");
		trace(Reg.puzzleMain.monster.name + " now has " + Reg.puzzleMain.monster.currentHP + " health.");
		
		announceText.alpha = 1;
		add(announceText);	
		
		var tween:FlxTween = FlxTween.multiVar(announceText, { alpha: 0 }, 1, { complete: onMessageRemoved } );
		
		//onFinalComplete();
	}
	
	override public function onFinalComplete(t:FlxTween = null):Void 
	{
		remove(announceText);
		announceText.exists = false;
		
		super.onFinalComplete(t);
	}
	
}