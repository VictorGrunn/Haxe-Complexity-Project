package puzzlebase.puzzprocess.combatmoves.encounters;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class AddEncounterProcess extends EncounterTemplate
{
	private var announceText:FlxText;

	public function new() 
	{
		super();
	}
	
	override public function begin():Void 
	{
		super.begin();				
		
		Reg.puzzleMain.monster = Reg.puzzleMain.encounterArray.shift();
		Reg.puzzleMain.monster.alpha = 0;
		Reg.puzzleMain.monster.launch();
		Reg.puzzleMain.add(Reg.puzzleMain.monster);
		
		Reg.puzzleMain.monster.x = Reg.puzzleMain.background.x + Reg.puzzleMain.background.width - Reg.puzzleMain.monster.width - 10;
		Reg.puzzleMain.monster.y = Reg.puzzleMain.background.y + Reg.puzzleMain.background.height - Reg.puzzleMain.monster.height - 25;
		
		trace("Monster is at " + Reg.puzzleMain.monster.x + " " + Reg.puzzleMain.monster.y);
		
		announceText = AssetsRegistry.giveNewText();
		announceText.text = Reg.puzzleMain.monster.name + " HAS ARRIVED!";
		announceText.setFormat(null, 14, 0xffffff, "center");
		announceText.alpha = 1;
		FlxSpriteUtil.screenCenter(announceText, true, true);
		add(announceText);
		
		var tween:FlxTween = FlxTween.multiVar(Reg.puzzleMain.monster, { alpha: 1 }, 1, { complete: onMonsterArrived } );
	}
	
	private function onMonsterArrived(t:FlxTween):Void
	{
		var tween:FlxTween = FlxTween.multiVar(announceText, { alpha: 0 }, 1, { complete: onFinalComplete } );
	}
	
	override public function onFinalComplete(t:FlxTween = null):Void 
	{
		remove(announceText);
		announceText.exists = false;
		
		super.onFinalComplete(t);
	}
	
}