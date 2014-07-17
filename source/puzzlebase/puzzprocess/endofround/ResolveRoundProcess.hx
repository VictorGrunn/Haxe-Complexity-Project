package puzzlebase.puzzprocess.endofround;
import flash.events.Event;
import flash.Lib;
import flixel.tweens.FlxTween;
import puzzlebase.puzzprocess.combatmoves.encounters.situations.SituationTemplate;
import puzzlebase.puzzprocess.ComputerMoveProcess;
import puzzlebase.puzzprocess.ProcessPart;
import puzzlebase.puzzprocess.SolutionCheckProcess;
import source.puzzlebase.puzzprocess.MovePieceProcess;
import puzzlebase.puzzprocess.combatmoves.playermoves.PlayerMoveTemplate;
import puzzlebase.puzzprocess.combatmoves.encounters.EncounterTemplate;

/**
 * ...
 * @author Victor Grunn
 */
class ResolveRoundProcess extends ProcessPart
{
	public var playerMoveArray:Array<PlayerMoveTemplate>;
	public var enemyMoveArray:Array<EncounterTemplate>;
	
	private var tickedYet:Bool = false;

	public function new() 
	{
		super();
		
		playerMoveArray = new Array();
		enemyMoveArray = new Array();
	}
	
	public function addPlayerMove(t:PlayerMoveTemplate):Void
	{
		playerMoveArray.push(t);
	}
	
	public function addEnemyMove(t:EncounterTemplate):Void
	{
		enemyMoveArray.push(t);
	}
	
	private function finishUp():Void
	{
		if (Reg.puzzleMain.rules.players == 1)
		{
			var playerMove:MovePieceProcess = new MovePieceProcess(Reg.puzzleMain);
			Reg.puzzleMain.rules.addToQueue(playerMove);
		}
		else
		{
			var solutionCheck:SolutionCheckProcess = new SolutionCheckProcess(Reg.puzzleMain, true);
			Reg.puzzleMain.rules.addToQueue(solutionCheck);
		}
		
		onFinalComplete();
	}
	
	override public function begin():Void 
	{
		super.begin();					
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e:Event):Void
	{
		if (playerMoveArray.length > 0)
		{			
			if (playerMoveArray[0].started == false)
			{
				add(playerMoveArray[0]);
				playerMoveArray[0].begin();
				return;
			}
			
			if (playerMoveArray[0].started && playerMoveArray[0].complete)
			{
				playerMoveArray.shift();
				return;
			}
			
			return;
		}
		
		if (tickedYet == false)
		{
			tickedYet = true;			
			
			if (Reg.puzzleMain.monster != null)
			{
				Reg.puzzleMain.monster.countdownRound();
			}
			
			return;
		}
		
		if (enemyMoveArray.length > 0)
		{
			if (enemyMoveArray[0].started == false)
			{
				enemyMoveArray[0].begin();
				add(enemyMoveArray[0]);
				return;
			}
			
			if (enemyMoveArray[0].started && enemyMoveArray[0].complete)
			{
				remove(enemyMoveArray[0]);
				enemyMoveArray.shift();
				return;
			}
			
			return;
		}
		
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		finishUp();
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void 
	{
		Reg.puzzleMain.rules.resolveRoundProcess = new ResolveRoundProcess();
		super.onFinalComplete(t);
	}
	
}