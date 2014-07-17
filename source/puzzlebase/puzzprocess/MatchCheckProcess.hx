package puzzlebase.puzzprocess;
import flixel.tweens.FlxTween;
import puzzlebase.combatgame.orders.RoundTickOrder;
import puzzlebase.PuzzlePiece;
import puzzlebase.PuzzMain;
import puzzlebase.puzzprocess.endofround.ResolveRoundProcess;

/**
 * ...
 * @author Victor Grunn
 */
class MatchCheckProcess extends ProcessPart
{
	private var puzzMain:PuzzMain;

	public function new(_main:PuzzMain) 
	{
		puzzMain = _main;		
		
		super();			
	}
	
	override public function begin():Void
	{
		super.begin();				
		
		checkMatches();
	}
	
	override public function onFinalComplete(t:FlxTween = null):Void
	{
		//puzzMain = null;
		super.onFinalComplete(t);
	}
	
	private function checkMatches():Void
	{				
		var removeCheckArray:Array<PieceRemoveProcess> = new Array();
		var pieceFlagged:Bool = false;
		
		//We loop throw the PuzzleRows in columnArray
		for (i in 0...puzzMain.columnArray.length)
		{			
			//And now we check through the puzzlepieces, in each PuzzleRow
			for (o in 0...puzzMain.columnArray[i].mainArray.length)
			{
				//If what's present is a puzzlePiece...
				if (Std.is(puzzMain.columnArray[i].mainArray[o], PuzzlePiece))
				{			
					var pieceName:String = puzzMain.columnArray[i].mainArray[o].name;
					var pieceArray:Array<PuzzlePiece> = new Array();
					
					//Loop through from left to right. Check to see if the puzzlepiece names match the initial puzzlepiece name. If they do, add them to an array.
					//For 3 or more, flush them.
					for (r in 0...puzzMain.columnArray.length)
					{
						if (puzzMain.columnArray[i + r] == null || (puzzMain.columnArray[i + r].mainArray[o] == null || puzzMain.columnArray[i + r].mainArray[o] != null && puzzMain.columnArray[i + r].mainArray[o].name != pieceName))
						{
							if (pieceArray.length >= 3)
							{																
								pieceFlagged = true;
								
								var removeProcess = new PieceRemoveProcess();
								
								for (i in 0...pieceArray.length)
								{									
									removeProcess.addPiece(pieceArray[i]);
									pieceArray[i].matchedHorizontal = true;
								}
								
								removeProcess.setType(Horizontal);
								removeCheckArray.push(removeProcess);
							}							
							
							pieceArray = null;							
							break;
						}
						else if (puzzMain.columnArray[i + r] != null && puzzMain.columnArray[i + r].mainArray[o] != null && puzzMain.columnArray[i + r].mainArray[o].name == pieceName)
						{
							if (puzzMain.columnArray[i + r].mainArray[o].matchedHorizontal == false)
							{
								pieceArray.push(puzzMain.columnArray[i + r].mainArray[o]);
							}
						}						
					}
					
					pieceArray = new Array();
						
					//Loop through from top to bottom, looking for matches.
					for (r in 0...puzzMain.columnArray[i].mainArray.length)
					{
						if (puzzMain.columnArray[i].mainArray[o + r] == null || puzzMain.columnArray[i].mainArray[o + r].name != pieceName)
						{
							if (pieceArray.length >= 3)
							{
								pieceFlagged = true;			
								
								var overlapPieces:Bool = false;
								var overlapProcess:PieceRemoveProcess = new PieceRemoveProcess();
								var removeProcess:PieceRemoveProcess;
								
								for (w in 0...removeCheckArray.length)
								{
									for (e in 0...pieceArray.length)
									{
										if (removeCheckArray[w].checkPresent(pieceArray[e]) && removeCheckArray[w].removeType == Horizontal)
										{
											overlapPieces = true;
											overlapProcess = removeCheckArray[w];
											overlapProcess.setType(Mixed);									
										}
									}
								}
								
								if (overlapPieces)
								{																											
									for (i in 0...pieceArray.length)
									{										
										pieceArray[i].matchedVertical = true;
										overlapProcess.addPiece(pieceArray[i]);																				
									}
								}
								else
								{
									removeProcess = new PieceRemoveProcess();
									removeProcess.setType(Vertical);
									
									for (i in 0...pieceArray.length)
									{										
										pieceArray[i].matchedVertical = true;
										removeProcess.addPiece(pieceArray[i]);
									}
									
									removeCheckArray.push(removeProcess);
								}								
							}														
							
							pieceArray = null;
							break;
						}
						else if (puzzMain.columnArray[i].mainArray[o + r].name != null && puzzMain.columnArray[i].mainArray[o + r].name == pieceName)
						{
							if (puzzMain.columnArray[i].mainArray[o + r].matchedVertical == false)
							{
								pieceArray.push(puzzMain.columnArray[i].mainArray[o + r]);
							}							
						}
					}					
				}				
			}
		}
		
		//Checking for duplicates of pieces between array members. If found, we combine them into a single array. I should have done this from the start, but I didn't so fuck me.
		for (i in 0...removeCheckArray.length)
		{
			if (removeCheckArray[i] != null)
			{
				for (o in 0...removeCheckArray[i].pieceArray.length)
				{
					for (p in 0...removeCheckArray.length)
					{
						if (removeCheckArray[p] == null)
						{							
							continue;
						}
						
						if (removeCheckArray[i] == removeCheckArray[p])
						{
							continue;
						}						
						
						for (q in 0...removeCheckArray[p].pieceArray.length)
						{													
							if (removeCheckArray[i].pieceArray[o] == removeCheckArray[p].pieceArray[q])
							{
								removeCheckArray[i].setType(Mixed);
								
								for (w in 0...removeCheckArray[p].pieceArray.length)
								{
									removeCheckArray[i].addPiece(removeCheckArray[p].pieceArray[w]);
								}
								
								removeCheckArray[p].flush();
								removeCheckArray[p] = null;
								break;
							}
						}
					}
				}
			}
		}
		
		for (i in 0...removeCheckArray.length)
		{						
			if (removeCheckArray[i] != null)
			{
				Reg.puzzleMain.rules.addToQueue(removeCheckArray[i]);			
				removeCheckArray[i] = null;
			}			
		}
		
		
		if (pieceFlagged == true)
		{
			var refill:RefillRowsProcess = new RefillRowsProcess(puzzMain);
			Reg.puzzleMain.rules.addToQueue(refill);
		}
		else
		{
			//var resolveRoundProcess:ResolveRoundProcess = new ResolveRoundProcess();
			Reg.puzzleMain.rules.addToQueue(Reg.puzzleMain.rules.resolveRoundProcess);
			//var roundTick:RoundTickOrder = new RoundTickOrder();
			//Reg.puzzleMain.fightScreen.addToQueue(roundTick);
		}
				
		removeCheckArray = null;
		
		onFinalComplete();
	}
	
	override public function flush():Void
	{
		super.flush();
		
		//puzzMain = null;
	}
	
}