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
	
	private var tweenArray:Array<FlxTween>;

	public function new(_puzzMain:PuzzMain) 
	{
		puzzMain = Reg.puzzleMain;
		tweenArray = new Array();
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
		if (tweenArray == null)
		{
			return;
		}
		
		var arrayCheck:Int = 0;				
		
		for (i in 0...tweenArray.length)
		{
			if (tweenArray[i].active == true)
			{
				arrayCheck += 1;				
			}
		}
				
		if (arrayCheck == 0)
		{			
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameRow);
			tweenArray = null;
			onFinalComplete();
		}
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void
	{
		var checkMatches:MatchCheckProcess = new MatchCheckProcess(Reg.puzzleMain);				
		
		puzzMain.rules.addToQueue(checkMatches);		
		
		tweenArray = null;
		
		//trace("This went off." + " " + Math.random());
		
		//puzzMain = null;		
		
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
			puzzlePiece.launch(null, _column);
			_column.mainArray[rowFillStart] = puzzlePiece;
			//mainClass.changeQueue(1);
			newPieceCount += 1;
			puzzlePiece.startingPoint.x = _column.location.x;
			puzzlePiece.startingPoint.y = _column.location.y - (puzzlePiece.height * newPieceCount);
			puzzlePiece.destinationPoint.x = _column.location.x;
			puzzlePiece.destinationPoint.y = _column.location.y + (puzzlePiece.height * rowFillStart) + (rowFillStart * _column.spaceBuffer);
			puzzlePiece.animType = FadeIn;
			animationArray.push(puzzlePiece);
			rowFillStart -= 1;
		}		
		
		rowMembers = null;
		
		//animatePieces(animationArray);		
		animate(animationArray);
		animationArray = null;
	}					
	
	override public function flush():Void
	{
		super.flush();		
		
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrameRow);		
		
		for (i in 0...tweenArray.length)
		{
			tweenArray[i].cancel();
		}
		
		tweenArray = null;
		
		//puzzMain = null;		
	}
	
	public function animate(?_array:Array<PuzzlePiece>, ?_piece:PuzzlePiece):Void
	{
		if (_array != null)
		{
			for (i in 0..._array.length)
			{
				animateHelper(_array[i]);
			}
		}
		
		_array = null;
	}
	
	private function animateHelper(_piece:PuzzlePiece):Void
	{	
		switch (_piece.animType)
		{
			case DropDown:
				var tween:FlxTween = FlxTween.linearMotion(_piece, _piece.startingPoint.x, _piece.startingPoint.y, _piece.destinationPoint.x, _piece.destinationPoint.y, Reg.puzzleMain.refillSpeed, false);	
				tweenArray.push(tween);
				
			case ScatterIn:
				var tween:FlxTween = FlxTween.cubicMotion(_piece, _piece.startingPoint.x, _piece.startingPoint.y, FlxRandom.floatRanged(0, FlxG.width), FlxRandom.floatRanged(0, FlxG.height), 
			FlxRandom.floatRanged(0, FlxG.width), FlxRandom.floatRanged(0, FlxG.height), _piece.destinationPoint.x, _piece.destinationPoint.y, 1);
			tweenArray.push(tween);
				
			case ShrinkOut:
				
			case RandomSlideIn:					
				var vChange:Int = 0;
				var hChange:Int = 0;
				if (FlxRandom.chanceRoll(50))
				{
					if (FlxRandom.chanceRoll(50))
					{
						hChange = 1000;
					}
					else
					{
						hChange = -1000;
					}
				}
				else
				{
					if (FlxRandom.chanceRoll(50))
					{
						vChange = 1000;
					}
					else
					{
						vChange = -1000;
					}
				}
				
				var tween:FlxTween = FlxTween.linearMotion(_piece, _piece.destinationPoint.x + hChange, _piece.destinationPoint.y + vChange, _piece.destinationPoint.x, _piece.destinationPoint.y, .45, true);
				tweenArray.push(tween);
				
			case FadeIn:
				_piece.alpha = 0;
				_piece.x = _piece.destinationPoint.x;
				_piece.y = _piece.destinationPoint.y;
				_piece.scale.x = 4;
				_piece.scale.y = 4;
				var tween:FlxTween = FlxTween.multiVar(_piece.scale, { x: 1, y: 1 }, .5);
				var tween2:FlxTween = FlxTween.multiVar(_piece, { alpha: 1 }, .51);				
				tweenArray.push(tween);
				tweenArray.push(tween2);
		}
	}	
}

enum AnimationType
{
	//Drops down from the top, classic 'refill the column' style.
	DropDown;
	
	//Arrives at destination point taking a crazy randomized path.
	ScatterIn;
	
	//Shrinks and then disappears. Used for getting rid of tiles.
	ShrinkOut;
	
	//Piece slides onto the screen randomly from cardinal directions.
	RandomSlideIn;
	
	//Piece starts out large and see-through, solidifies to solid and normal sized
	FadeIn;
}