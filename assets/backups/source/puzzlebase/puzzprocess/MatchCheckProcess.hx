package puzzlebase.puzzprocess;
import flixel.tweens.FlxTween;
import puzzlebase.PuzzlePiece;
import puzzlebase.PuzzMain;

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
		puzzMain = null;
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
					//For 3 or more, flush them. Except for the first one! We need THAT one for the horizontal check, which is coming next.
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
		for (i in 0...removeCheckArray.length)
		{
			trace("Type is: " + removeCheckArray[i].removeType);
			
			trace("This went off.");
			Reg.puzzleMain.rules.addToQueue(removeCheckArray[i]);			
		}
		
		
		if (pieceFlagged == true)
		{
			var refill:RefillRowsProcess = new RefillRowsProcess(puzzMain);
			Reg.puzzleMain.rules.addToQueue(refill);
		}
				
		removeCheckArray = null;
		
		onFinalComplete();
	}
	
}