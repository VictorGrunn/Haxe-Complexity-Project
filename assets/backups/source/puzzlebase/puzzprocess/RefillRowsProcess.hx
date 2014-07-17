package puzzlebase.puzzprocess;
import flash.events.Event;
import flash.Lib;
import puzzlebase.PuzzleRow;
import puzzlebase.PuzzMain;
import puzzlebase.PuzzlePiece;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.FlxG;
import puzzlebase.animator.PieceAnimator;

/**
 * ...
 * @author Victor Grunn
 */
class RefillRowsProcess extends ProcessPart
{
	private var puzzMain:PuzzMain;	

	public function new(_puzzMain:PuzzMain) 
	{
		puzzMain = _puzzMain;		
		super();				
	}
	
	override public function begin():Void
	{
		super.begin();
		
		for (i in 0...puzzMain.columnArray.length)
		{			
			populateColumn(puzzMain.columnArray[i]);
		}		
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrameRow);
	}
	
	private function onEnterFrameRow(e:Event):Void
	{
		if (PieceAnimator.animationsInProcess == 0)
		{
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameRow);
			onFinalComplete();
		}
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void
	{
		var checkMatches:MatchCheckProcess = new MatchCheckProcess(puzzMain);
		puzzMain.rules.addToQueue(checkMatches);
		
		//trace("This went off." + " " + Math.random());
		
		puzzMain = null;
		
		super.onFinalComplete(t);
	}
	
	public function populateColumn(_column:PuzzleRow):Void
	{		
		var rowMembers:Array<PuzzlePiece> = new Array();
		var takeRowMembers:Bool = false;
		var rowFillStart:Int = 0;
		var animationArray:Array<PuzzlePiece> = new Array();
		
		/* Check the Mainarray in reverse order for the first instance of a null. If one is found, then takeRowMembers is set to true,	
		and we know from what point we need to start accounting for any and all remaining puzzle pieces to shift ahead.
		*/
		for (i in 0..._column.rowSize)
		{
			if (_column.mainArray[(_column.rowSize - 1) - i] == null)
			{
				//trace("We just checked " + ((rowSize - 1) - i) + " and found " + mainArray[(rowSize - 1) - i]);
				takeRowMembers = true;
				rowFillStart = _column.rowSize - 1 - i;
				//trace("rowFillStart initializing at: " + rowFillStart);
				break;
			}
		}
		
		/* If takeRowMembers is false, that means no empty/null member of mainArray was found, so we don't need to populate anything after all. Ergo, return out of this function.
		 * Let's trace our result just for the hell of it.
		 */
		if (takeRowMembers == false)
		{
			//trace("Nothing found to do in populateRow in PuzzleRow.");
			return;
		}
		
		/* If, however, takeRowMembers was triggered, that means we have some work to do.
		 * In particular, we're going to check the mainArray in order. Any PuzzlePieces we find will be added to the end of rowMembers in the order found. So, pieces occupying spaces
		 * 7 5 and 3 would ultimately be added as 7, 5, and 3. That way we can move everything in order when we move them downwards. We also remove them from the mainArray, so they can be
		 * re-added in order after moving.
		 */
		if (takeRowMembers == true)
		{
			
			for (i in 0...rowFillStart)
			{
				if (_column.mainArray[i] != null)
				{
					rowMembers.unshift(_column.mainArray[i]);
					_column.mainArray[i] = null;
				}
			}
		}		
		
		//trace("First rowMembers: " + rowMembers);
		
		/*
		 * Now, we tween each of the members of rowMembers into position, starting from rowFillStart and working backwards. What's more, we add the pieces to their new position in the row.
		 * This may still leave some empty row spaces left over.
		 */
		if (rowMembers.length > 0)		
		{
			for (i in 0...rowMembers.length)
			{
				var puzzlePiece:PuzzlePiece = rowMembers.shift();
				//mainClass.changeQueue(1);
				_column.mainArray[rowFillStart] = puzzlePiece;
				puzzlePiece.startingPoint.x = puzzlePiece.x;
				puzzlePiece.startingPoint.y = puzzlePiece.y;
				puzzlePiece.destinationPoint.x = puzzlePiece.x;
				puzzlePiece.destinationPoint.y = _column.location.y + (puzzlePiece.height * rowFillStart) + (rowFillStart * _column.spaceBuffer);								
				puzzlePiece.animType = DropDown;
				animationArray.push(puzzlePiece);								
				
				rowFillStart -= 1;				
			}
		}
		
		/*
		 * Naturally we now have to update rowFillStart to make sure it's working from the right location and number.
		 */		
		for (i in 0..._column.rowSize)
		{
			if (_column.mainArray[(_column.rowSize - 1) - i] == null)
			{
				takeRowMembers = true;
				rowFillStart = _column.rowSize - 1 - i;
				break;
			}
		}
		
		
		var newPieceCount:Int = 1;
		
		/*
		 * Now, we deal with any remaining empty spaces, adding in new puzzle pieces, and counting down rowFillStart. At -1, this should stop.
		 */
		while (rowFillStart >= 0)
		{
			var puzzlePiece:PuzzlePiece = _column.puzzleGroup.recycle(PuzzlePiece);
			chooseColor(puzzlePiece, _column);			
			_column.mainArray[rowFillStart] = puzzlePiece;
			//mainClass.changeQueue(1);
			newPieceCount += 1;
			puzzlePiece.startingPoint.x = _column.location.x;
			puzzlePiece.startingPoint.y = _column.location.y - (puzzlePiece.height * newPieceCount);
			puzzlePiece.destinationPoint.x = _column.location.x;
			puzzlePiece.destinationPoint.y = _column.location.y + (puzzlePiece.height * rowFillStart) + (rowFillStart * _column.spaceBuffer);
			puzzlePiece.animType = AnimationType.FadeIn;
			animationArray.push(puzzlePiece);
			rowFillStart -= 1;
		}		
		
		rowMembers = null;
		
		//animatePieces(animationArray);		
		PieceAnimator.animate(animationArray);
		animationArray = null;
	}			
		
	//Use to generate the initial colors/types of puzzle pieces.
	private function chooseColor(t:PuzzlePiece, _row:PuzzleRow):Void
	{
		var lucknum:Int = Math.floor(Math.random() * 6);
		
		switch (lucknum)
		{
			case 0:
				t.launch(Red, _row);
				
			case 1:
				t.launch(Green, _row);
				
			case 2:
				t.launch(Blue, _row);			
				
			case 3:
				t.launch(Purple, _row);
				
			case 4:
				t.launch(Yellow, _row);
				
			case 5:
				t.launch(Black, _row);
				
		}
	}
	
}