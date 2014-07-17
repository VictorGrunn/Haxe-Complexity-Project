package puzzlebase.rules;
import puzzlebase.puzzprocess.ComputerMoveProcess;
import puzzlebase.puzzprocess.ProcessPart;
import puzzlebase.puzzprocess.SolutionCheckProcess;

/**
 * ...
 * @author Victor Grunn
 */
class StandardRules
{
	public var ruleQueue:Array<ProcessPart>;

	public function new() 
	{
		ruleQueue = new Array();			
	}
	
	public function nextMove():Void
	{
		if (ruleQueue != null && ruleQueue.length > 0)
		{
			if (ruleQueue[0].complete)
			{
				//trace("Rule removed: " + ruleQueue[0]);
				ruleQueue.shift();				
				//trace("New Rule: " + ruleQueue[0]);
			}
		}
		
		if (ruleQueue[0] != null)
		{
			ruleQueue[0].begin();
		}		
		
		if (ruleQueue.length == 0)
		{
			var botmatch:SolutionCheckProcess = new SolutionCheckProcess(Reg.puzzleMain, true);
			addToQueue(botmatch);
		}
	}
	
	public function addToQueue(_part:ProcessPart):Void
	{
		if (ruleQueue.length == 0)
		{
			ruleQueue.push(_part);
			ruleQueue[0].begin();			
		}
		else
		{
			ruleQueue.push(_part);
		}
	}
	
}