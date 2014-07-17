package puzzlebase.rules;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxPoint;
import puzzlebase.puzzprocess.combatmoves.playermoves.PlayerMoveTemplate;
import puzzlebase.puzzprocess.ComputerMoveProcess;
import puzzlebase.puzzprocess.endofround.ResolveRoundProcess;
import puzzlebase.puzzprocess.ProcessPart;
import puzzlebase.puzzprocess.SolutionCheckProcess;
import puzzlebase.puzzprocess.specialmoves.ClearColorSpecial;
import puzzlebase.puzzprocess.specialmoves.ClearHorizontalSpecial;
import source.puzzlebase.puzzprocess.MovePieceProcess;
import source.puzzlebase.puzzprocess.PuzzleInitializeProcess;
import puzzlebase.puzzprocess.RefillRowsProcess;
import puzzlebase.puzzprocess.PieceRemoveProcess;
import puzzlebase.PuzzlePiece;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class StandardRules extends FlxGroup
{
	public var ruleQueue:Array<ProcessPart>;
	public var gameStats:GameStats;
	
	public var players:Int = 1;
	
	private var statistics:FlxText;
		
	public var resolveRoundProcess:ResolveRoundProcess;

	public function new() 
	{
		super();
		
		trace("This was initialized.");
		
		ruleQueue = new Array();
		gameStats = new GameStats();
		
		//statistics = AssetsRegistry.masterTextGroup.recycle(FlxText, [0, 0, Std.int(FlxG.width / 3.5), "", 12]);		
		statistics = AssetsRegistry.giveNewText();
		statistics.width = 180;
		statistics.scale = new FlxPoint(1.5, 1.5);
		statistics.x = FlxG.width - statistics.width;		
		gameStats.giveData();
		statistics.text = gameStats.giveData();
		statistics.draw();
		statistics.y = FlxG.height - statistics.height - 100;
		add(statistics);
		
		resolveRoundProcess = new ResolveRoundProcess();
	}
	
	public function nextMove():Void
	{
		if (ruleQueue != null && ruleQueue.length > 0)
		{
			if (ruleQueue[0].complete)
			{
				remove(ruleQueue[0]);
				ruleQueue.shift();				
			}
		}
		
		if (ruleQueue[0] != null)
		{
			add(ruleQueue[0]);
			ruleQueue[0].begin();
		}		
		
		if (ruleQueue.length == 0)
		{
			addToQueue(resolveRoundProcess);
		}
	}
	
	private function playerMove():Void
	{
		var movePieceProcess = new MovePieceProcess(Reg.puzzleMain);
		statistics.text = gameStats.giveData();
		addToQueue(movePieceProcess);
	}
	
	private function computerMove():Void
	{
		var botmatch:SolutionCheckProcess = new SolutionCheckProcess(Reg.puzzleMain, true);
		addToQueue(botmatch);
	}
	
	private function clearReds():Void
	{
		if (gameStats.redMatched > 10)
			{
				gameStats.redMatched = 0;				
				var clearPieces:ClearColorSpecial = new ClearColorSpecial(Reg.puzzleMain, Red);				
				statistics.text = gameStats.giveData();
				return;
			}
	}
	
	public function addToQueue(_part:ProcessPart):Void
	{
		if (ruleQueue.length == 0)
		{
			ruleQueue.push(_part);
			add(ruleQueue[0]);
			ruleQueue[0].begin();			
		}
		else
		{
			ruleQueue.push(_part);
		}
	}
	
	public function addOverrideToQueue(_part:ProcessPart):Void
	{			
		//trace(ruleQueue[0] + " was removed. " + Math.random());
		//trace("Total queue: " + ruleQueue);				
		
		if (Std.is(ruleQueue[0], MovePieceProcess) || Std.is(ruleQueue[0], ComputerMoveProcess) || Std.is(ruleQueue[0], RefillRowsProcess) || Std.is(ruleQueue[0], PieceRemoveProcess))
		{			
			remove(ruleQueue[0]);
			ruleQueue[0].flush();
		}								
		
		ruleQueue = new Array();
		ruleQueue.push(_part);
		ruleQueue[0].begin();
	}
	
	public function updateData():Void
	{
		statistics.text = gameStats.giveData();
	}
	
	override public function destroy():Void
	{
		if (ruleQueue == null)
		{
			trace("For some reason, this was null.");
			return;
		}
		
		for (i in 0...ruleQueue.length)
		{
			if (ruleQueue[i] != null)
			{
				ruleQueue[i].flush();
				ruleQueue[i] = null;
			}			
		}
		
		statistics.exists = false;
		
		ruleQueue = null;
		
		super.destroy();
	}	
}