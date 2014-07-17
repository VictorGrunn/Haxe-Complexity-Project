package puzzlebase.puzzprocess.combatmoves.encounters.monsters;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;
import puzzlebase.combatgame.monsters.Goblin;
import puzzlebase.puzzprocess.combatmoves.encounters.AddEncounterProcess;
import puzzlebase.puzzprocess.combatmoves.encounters.situations.SituationTemplate;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class RemoveMonsterProcess extends SituationTemplate
{
	private var announceText:FlxText;

	public function new() 
	{
		super();
		
		announceText = AssetsRegistry.giveNewText();
		announceText.alpha = 1;
		announceText.text = Reg.puzzleMain.monster.name + " HAS BEEN DEFEATED!";
		announceText.setFormat(null, 14, 0xffffff, "center");
		FlxSpriteUtil.screenCenter(announceText, true, true);
		add(announceText);		
		
		var tween:FlxTween = FlxTween.multiVar(Reg.puzzleMain.monster, { alpha: 0 }, 1, { complete: onMonsterRemoved } );
	}
	
	private function onMonsterRemoved(t:FlxTween):Void
	{
		var tween:FlxTween = FlxTween.multiVar(announceText, { alpha: 0 }, 1, { complete: onFinalComplete } );
	}
	
	override public function begin():Void 
	{
		super.begin();
	}		
	
	override public function onFinalComplete(t:FlxTween = null):Void 
	{
		remove(announceText);
		announceText.exists = false;
		Reg.puzzleMain.monster.exists = false;
		Reg.puzzleMain.remove(Reg.puzzleMain.monster);
		
		if (Reg.puzzleMain.encounterArray.length > 0)
		{
			var addEncounter:AddEncounterProcess = new AddEncounterProcess();
			Reg.puzzleMain.rules.resolveRoundProcess.addEnemyMove(addEncounter);
		}
		else
		{
			Reg.puzzleMain.encounterArray = [new Goblin(), new Goblin(), new Goblin()];
			var addEncounter:AddEncounterProcess = new AddEncounterProcess();
			Reg.puzzleMain.rules.resolveRoundProcess.addEnemyMove(addEncounter);
		}
		
		super.onFinalComplete(t);
	}
	
}