package puzzlebase.puzzprocess;
import flixel.tweens.FlxTween;
import puzzlebase.PuzzMain;
import puzzlebase.PuzzleRow;
import puzzlebase.PuzzlePiece;
import source.puzzlebase.puzzprocess.EraseBoardProcess;

/**
 * ...
 * @author Victor Grunn
 */
class SolutionCheckProcess extends ProcessPart
{
	private var puzzMain:PuzzMain;
	private var columnArray:Array<PuzzleRow>;
	private var computerPlayer:Bool = false;

	//Checks for solutions, and if set, will automate a robot move.
	public function new(_puzzMain:PuzzMain, _compPlayer:Bool) 
	{
		super();
		
		puzzMain = _puzzMain;		
		columnArray = puzzMain.columnArray;	
		computerPlayer = _compPlayer;
	}
	
	override public function begin():Void
	{
		areThereSolutions();
	}
	
	private function areThereSolutions():Bool
	{		
		var solutionCheck:Bool = false;
		
		var solutionArray:Array<PuzzlePiece> = new Array();
		var solutionPairs:Array<Array<PuzzlePiece>> = new Array();
		
		for (i in 0...columnArray.length)
		{
			for (o in 0...columnArray[i].mainArray.length)
			{
				//This makes a check based on the initial presence of two vertically matched pieces side by side
				if (columnArray[i].mainArray[o + 1] != null && columnArray[i].mainArray[o].name == columnArray[i].mainArray[o + 1].name)
				{
					//Checking to the left side, top and bottom
					if (columnArray[i - 1] != null)
					{
						if (columnArray[i - 1].mainArray[o - 1] != null && columnArray[i - 1].mainArray[o - 1].name == columnArray[i].mainArray[o].name)
						{							
							/*columnArray[i - 1].mainArray[o - 1].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i].mainArray[o + 1].alpha = .5;*/
							
							solutionArray.push(columnArray[i - 1].mainArray[o - 1]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i].mainArray[o + 1]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i - 1].mainArray[o - 1]);
							parray.push(columnArray[i].mainArray[o - 1]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
						
						if (columnArray[i - 1].mainArray[o + 2] != null && columnArray[i - 1].mainArray[o + 2].name == columnArray[i].mainArray[o].name)
						{
							/*columnArray[i - 1].mainArray[o + 2].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i].mainArray[o + 1].alpha = .5;*/
							
							solutionArray.push(columnArray[i - 1].mainArray[o + 2]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i].mainArray[o + 1]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i - 1].mainArray[o + 2]);
							parray.push(columnArray[i].mainArray[o + 2]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
					}
					
					//Checking to the right side, top and bottom
					if (columnArray[i + 1] != null)
					{
						if (columnArray[i + 1].mainArray[o - 1] != null && columnArray[i + 1].mainArray[o - 1].name == columnArray[i].mainArray[o].name)
						{
							/*columnArray[i + 1].mainArray[o - 1].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i].mainArray[o + 1].alpha = .5;*/
							
							solutionArray.push(columnArray[i + 1].mainArray[o - 1]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i].mainArray[o + 1]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i + 1].mainArray[o - 1]);
							parray.push(columnArray[i].mainArray[o - 1]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
						
						if (columnArray[i + 1].mainArray[o + 2] != null && columnArray[i + 1].mainArray[o + 2].name == columnArray[i].mainArray[o].name)
						{
							/*columnArray[i + 1].mainArray[o + 2].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i].mainArray[o + 1].alpha = .5;*/
							
							solutionArray.push(columnArray[i + 1].mainArray[o + 2]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i].mainArray[o + 1]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i + 1].mainArray[o + 2]);
							parray.push(columnArray[i].mainArray[o + 2]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
					}
					
					//Checking behind two spaces
					if (columnArray[i].mainArray[o - 2] != null && columnArray[i].mainArray[o - 2].name == columnArray[i].mainArray[o].name)
					{
						/*columnArray[i].mainArray[o - 2].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i].mainArray[o + 1].alpha = .5;*/
						
						solutionArray.push(columnArray[i].mainArray[o - 2]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i].mainArray[o + 1]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i].mainArray[o - 2]);
						parray.push(columnArray[i].mainArray[o - 1]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
					
					//Checking ahead 2 spaces from the second partner
					if (columnArray[i].mainArray[o + 3] != null && columnArray[i].mainArray[o + 3].name == columnArray[i].mainArray[o].name)
					{
						/*columnArray[i].mainArray[o + 3].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i].mainArray[o + 1].alpha = .5;*/
						
						solutionArray.push(columnArray[i].mainArray[o + 3]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i].mainArray[o + 1]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i].mainArray[o + 3]);
						parray.push(columnArray[i].mainArray[o + 2]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
					
				}
				
				//This makes a check based on the initial presence of two horizontally matched pieces side by side
				if (columnArray[i + 1] != null && columnArray[i + 1].mainArray[o] != null && columnArray[i + 1].mainArray[o].name == columnArray[i].mainArray[o].name)
				{				
					//Checking top and bottom, left side
					if (columnArray[i - 1] != null)
					{
						if (columnArray[i - 1].mainArray[o - 1] != null && columnArray[i - 1].mainArray[o - 1].name == columnArray[i].mainArray[o].name)
						{
							/*columnArray[i - 1].mainArray[o - 1].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i + 1].mainArray[o].alpha = .5;*/
							
							solutionArray.push(columnArray[i - 1].mainArray[o - 1]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i + 1].mainArray[o]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i - 1].mainArray[o - 1]);
							parray.push(columnArray[i - 1].mainArray[o]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
						
						if (columnArray[i - 1].mainArray[o + 1] != null && columnArray[i - 1].mainArray[o + 1].name == columnArray[i].mainArray[o].name)
						{
							
							/*columnArray[i - 1].mainArray[o + 1].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i + 1].mainArray[o].alpha = .5;*/
							
							solutionArray.push(columnArray[i - 1].mainArray[o + 1]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i + 1].mainArray[o]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i - 1].mainArray[o + 1]);
							parray.push(columnArray[i - 1].mainArray[o]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
					}
					
					//checking top and bottom, right side
					if (columnArray[i + 2] != null)
					{
						if (columnArray[i + 2].mainArray[o - 1] != null && columnArray[i + 2].mainArray[o - 1].name == columnArray[i].mainArray[o].name)
						{
							/*columnArray[i + 2].mainArray[o - 1].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i + 1].mainArray[o].alpha = .5;*/
							
							solutionArray.push(columnArray[i + 2].mainArray[o - 1]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i + 1].mainArray[o]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i + 2].mainArray[o - 1]);
							parray.push(columnArray[i + 2].mainArray[o]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
						
						if (columnArray[i + 2].mainArray[o + 1] != null && columnArray[i + 2].mainArray[o + 1].name == columnArray[i].mainArray[o].name)
						{
							/*columnArray[i + 2].mainArray[o + 1].alpha = .5;
							columnArray[i].mainArray[o].alpha = .5;
							columnArray[i + 1].mainArray[o].alpha = .5;*/
							
							solutionArray.push(columnArray[i + 2].mainArray[o + 1]);
							solutionArray.push(columnArray[i].mainArray[o]);
							solutionArray.push(columnArray[i + 1].mainArray[o]);
							
							var parray:Array<PuzzlePiece> = new Array();
							parray.push(columnArray[i + 2].mainArray[o + 1]);
							parray.push(columnArray[i + 2].mainArray[o]);
							solutionPairs.push(parray);
							
							solutionCheck = true;
						}
					}
					
					//Checking behind two spaces
					if (columnArray[i - 2] != null && columnArray[i - 2].mainArray[o] != null && columnArray[i - 2].mainArray[o].name == columnArray[i].mainArray[o].name)
					{
						/*columnArray[i - 2].mainArray[o].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i + 1].mainArray[o].alpha = .5;*/
						
						solutionArray.push(columnArray[i - 2].mainArray[o]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i + 1].mainArray[o]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i - 2].mainArray[o]);
						parray.push(columnArray[i - 1].mainArray[o]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
					
					//Checking ahead 2 spaces from the second partner
					if (columnArray[i + 3] != null && columnArray[i + 3].mainArray[o] != null && columnArray[i + 3].mainArray[o].name == columnArray[i].mainArray[o].name)
					{
						/*columnArray[i + 3].mainArray[o].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i + 1].mainArray[o].alpha = .5;*/
						
						solutionArray.push(columnArray[i + 3].mainArray[o]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i + 1].mainArray[o]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i + 3].mainArray[o]);
						parray.push(columnArray[i + 2].mainArray[o]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
				}
				
				//This makes a check based on the initial presence two vertically matching tiles, 1 space apart
				if (columnArray[i].mainArray[o + 2] != null && columnArray[i].mainArray[o + 2].name == columnArray[i].mainArray[o].name)
				{
					//Checking to the left
					if (columnArray[i - 1] != null && columnArray[i - 1].mainArray[o + 1] != null && columnArray[i - 1].mainArray[o + 1].name == columnArray[i].mainArray[o].name)
					{												
						/*columnArray[i - 1].mainArray[o + 1].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i].mainArray[o + 2].alpha = .5;*/
						
						solutionArray.push(columnArray[i - 1].mainArray[o + 1]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i].mainArray[o + 2]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i - 1].mainArray[o + 1]);
						parray.push(columnArray[i].mainArray[o + 1]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
					
					//Checking to the right
					if (columnArray[i + 1] != null && columnArray[i + 1].mainArray[o + 1] != null && columnArray[i + 1].mainArray[o + 1].name == columnArray[i].mainArray[o].name)
					{
						/*columnArray[i + 1].mainArray[o + 1].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i].mainArray[o + 2].alpha = .5;*/
						
						solutionArray.push(columnArray[i + 1].mainArray[o + 1]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i].mainArray[o + 2]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i + 1].mainArray[o + 1]);
						parray.push(columnArray[i].mainArray[o + 1]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
				}
				
				//This makes a check based on the initial presence of two horizontally matched tiles, 1 space apart
				if (columnArray[i + 2] != null && columnArray[i + 2].mainArray[o] != null && columnArray[i + 2].mainArray[o].name == columnArray[i].mainArray[o].name)
				{
					//Checking up
					if (columnArray[i + 1] != null && columnArray[i + 1].mainArray[o - 1] != null && columnArray[i + 1].mainArray[o - 1].name == columnArray[i].mainArray[o].name)
					{
						/*columnArray[i + 1].mainArray[o - 1].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i + 2].mainArray[o].alpha = .5;*/
						
						solutionArray.push(columnArray[i + 1].mainArray[o - 1]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i + 2].mainArray[o]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i + 1].mainArray[o - 1]);
						parray.push(columnArray[i + 1].mainArray[o]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
					
					//Checking down
					if (columnArray[i + 1] != null && columnArray[i + 1].mainArray[o + 1] != null && columnArray[i + 1].mainArray[o + 1].name == columnArray[i].mainArray[o].name)
					{
						/*columnArray[i + 1].mainArray[o + 1].alpha = .5;
						columnArray[i].mainArray[o].alpha = .5;
						columnArray[i + 2].mainArray[o].alpha = .5;*/
						
						solutionArray.push(columnArray[i + 1].mainArray[o + 1]);
						solutionArray.push(columnArray[i].mainArray[o]);
						solutionArray.push(columnArray[i + 2].mainArray[o]);
						
						var parray:Array<PuzzlePiece> = new Array();
						parray.push(columnArray[i + 1].mainArray[o + 1]);
						parray.push(columnArray[i + 1].mainArray[o]);
						solutionPairs.push(parray);
						
						solutionCheck = true;
					}
				}				
			}						
		}
		
		if (solutionCheck == false)
		{
			//throw "There were no solutions?";
			var eraseBoard:EraseBoardProcess = new EraseBoardProcess(puzzMain);
			puzzMain.rules.addOverrideToQueue(eraseBoard);
			trace("We had a lack of solutions.");
		}
		
		if (computerPlayer == true && solutionCheck == true)
		{						
			var nextMoveNumber:Int = Math.floor(Math.random() * solutionPairs.length);
			var moveProcess:ComputerMoveProcess = new ComputerMoveProcess(solutionPairs[nextMoveNumber][0], solutionPairs[nextMoveNumber][1]);
			Reg.puzzleMain.rules.addToQueue(moveProcess);
		}		
		
		columnArray = null;
		puzzMain = null;
		
		for (i in 0...solutionPairs.length)
		{
			solutionPairs[i] = null;
		}
		
		solutionPairs = null;
		solutionArray = null;
		
		onFinalComplete();
		
		//trace("There were " + solutionPairs.length + " solutions.");				
		
		return solutionCheck;
	}	
	
	override public function flush():Void
	{
		super.flush();
		
		puzzMain = null;
		columnArray = null;
	}
}