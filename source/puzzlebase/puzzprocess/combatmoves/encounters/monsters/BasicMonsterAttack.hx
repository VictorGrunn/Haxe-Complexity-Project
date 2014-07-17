package puzzlebase.puzzprocess.combatmoves.encounters.monsters;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import puzzlebase.puzzprocess.combatmoves.encounters.situations.SituationTemplate;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class BasicMonsterAttack extends SituationTemplate
{
	private var announceText:FlxText;
	private var attackDamage:Int;

	public function new(_amount:Int) 
	{
		super();
		
		attackDamage = _amount;						
	}
	
	override public function begin():Void 
	{					
		Reg.puzzleMain.player.takeDamage(attackDamage);
		
		var newHPRatio:Float = Reg.puzzleMain.player.currentHP / Reg.puzzleMain.player.maxHP;
		
		announceText = AssetsRegistry.giveNewText();
		announceText.alpha = 0;
		announceText.text = Reg.puzzleMain.monster + " has attacked for " + attackDamage + " damage!";
		announceText.setFormat(null, 14, 0xffffff, "center");		
		FlxSpriteUtil.screenCenter(announceText, true, true);
		
		add(announceText);
		announceText.alpha = 1;
		
		var tween:FlxTween = FlxTween.multiVar(Reg.puzzleMain.playerHP.HPBar.scale, { x: newHPRatio }, .65, { ease: FlxEase.quadOut } );
		var tween2:FlxTween = FlxTween.multiVar(announceText, { alpha: 0 }, 1, { complete: onFinalComplete } );
		
		super.begin();
	}
	
	override public function onFinalComplete(t:FlxTween = null):Void 
	{
		remove(announceText);
		announceText.exists = false;
		
		super.onFinalComplete(t);
	}
	
}