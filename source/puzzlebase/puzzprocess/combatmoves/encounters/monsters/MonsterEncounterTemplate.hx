package puzzlebase.puzzprocess.combatmoves.encounters.monsters;
import flixel.tweens.FlxTween;
import puzzlebase.combatgame.monsters.MonsterTemplate;
import puzzlebase.puzzprocess.combatmoves.encounters.EncounterTemplate;
import puzzlebase.puzzprocess.combatmoves.encounters.situations.SituationTemplate;

/**
 * ...
 * @author Victor Grunn
 */
class MonsterEncounterTemplate extends EncounterTemplate
{
	private var monster:MonsterTemplate;

	public function new(_monster:MonsterTemplate) 
	{
		super();
		
		monster = _monster;
		monster.alpha = 0;
	}	
	
	override public function begin():Void 
	{
		super.begin();
		
		Reg.puzzleMain.monster = monster;
		trace(monster.name + " has arrived!");
		var tween:FlxTween = FlxTween.multiVar(monster, { alpha: 1 }, 1);
	}			
}