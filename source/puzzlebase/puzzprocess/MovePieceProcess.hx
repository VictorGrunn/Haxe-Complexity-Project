package source.puzzlebase.puzzprocess;
import flash.events.Event;
import flash.Lib;
import flixel.text.FlxText;
import puzzlebase.PuzzMain;
import puzzlebase.puzzprocess.ProcessPart;
import flixel.FlxG;
import puzzlebase.PuzzlePiece;
import puzzlebase.PuzzleRow;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import puzzlebase.puzzprocess.MatchCheckProcess;
import puzzlebase.puzzprocess.specialmoves.ClearHorizontalSpecial;

/**
 * ...
 * @author Victor Grunn
 */
class MovePieceProcess extends ProcessPart
{
	private var mousePoint:FlxPoint;
	private var columnArray:Array<PuzzleRow>;
	private var puzzMain:PuzzMain;
	private var pieceTarget:PuzzlePiece;
	private var columnTarget:PuzzleRow;
	
	private var moving:Bool = false;	
	
	public function new(_main:PuzzMain)
	{
		super();
		
		puzzMain = _main;
		columnArray = _main.columnArray;								
	}
	
	override public function begin():Void
	{
		super.begin();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void
	{
		var newProcess:MatchCheckProcess = new MatchCheckProcess(puzzMain);	
		puzzMain.rules.addToQueue(newProcess);
		moving = false;
		
		columnArray = null;
		columnTarget = null;
		pieceTarget = null;
		mousePoint = null;
		puzzMain = null;
		
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		super.onFinalComplete();		
	}	
	
	private function onEnterFrame(e:Event):Void
	{
		if (moving == false)
		{
			movePiece();
		}				
	}
	
	/*
	 * This function handles selecting and moving puzzle pieces onscreen. The actual puzzlePiece waits for an overlap and mousepress check, assigning pieceTarget
	 * the relevant targets. When the mouse moves far enough way from its origin, it checks to see if there's a relevant row or column to the left/right/up/down, and if so, if
	 * there is a valid match there.
	 */
	private function movePiece():Void
	{
		
		if (FlxG.mouse.justPressed)
		{
			mousePoint = FlxG.mouse.getScreenPosition();
			
			var pieceFound:Bool = false;
			
			for (i in 0...columnArray.length)
			{
				for (o in 0...columnArray[i].mainArray.length)
				{
					if (mousePoint.x > columnArray[i].mainArray[o].x && mousePoint.x < columnArray[i].mainArray[o].x + columnArray[i].mainArray[o].width)
					{
						if (mousePoint.y > columnArray[i].mainArray[o].y && mousePoint.y < columnArray[i].mainArray[o].y + columnArray[i].mainArray[o].height)
						{
							pieceTarget = columnArray[i].mainArray[o];
							pieceFound = true;
						}
					}
				}
			}
			
			if (pieceFound == false)
			{
				pieceTarget = null;
			}
		}
		
		if (FlxG.mouse.justReleased)
		{
			pieceTarget = null;
		}
		
		if (FlxG.mouse.pressed && pieceTarget != null && mousePoint != null)
		{
			var shiftAmount:Int = 30;
			
			if (FlxG.mouse.screenX > mousePoint.x + shiftAmount)
			{
				checkPiece(RIGHT);
				mousePoint = null;
			}
			else if (FlxG.mouse.screenX < mousePoint.x - shiftAmount)
			{
				checkPiece(LEFT);
				mousePoint = null;
			}
			else if (FlxG.mouse.screenY > mousePoint.y + shiftAmount)
			{
				checkPiece(DOWN);
				mousePoint = null;
			}
			else if (FlxG.mouse.screenY < mousePoint.y - shiftAmount)
			{
				checkPiece(UP);
				mousePoint = null;
			}			
		}
	}
	
	/*If a match check is successful, this tweens the two pieces into each other's place. It's also responsible for making sure they get each other's array assignment in
	 * their respective rows so they can be properly processed.
	 */
	private function tradePlaces(_piece1:PuzzlePiece, _piece2:PuzzlePiece):Void
	{
		//trace("Swapping piece 1 at " + _piece1.x + " " + _piece1.y + " with " + _piece2.x + " " + _piece2.y);		
		
		moving = true;
		
		var column1:Int = -1;
		var row1:Int = -1;
		var rowassignment1:PuzzleRow = _piece1.rowAssignment;
		
		var column2:Int = -1;
		var row2:Int = -1;
		var rowassignment2:PuzzleRow = _piece2.rowAssignment;
		
		var temp_x:Float;
		var temp_y:Float;
		var temp_rowassignment:PuzzleRow;				
		
		for (i in 0...columnArray.length)
		{
			if (columnArray[i] == _piece1.rowAssignment)
			{
				column1 = i;				
			}
			
			if (columnArray[i] == _piece2.rowAssignment)
			{
				column2 = i;
			}
		}
		
		for (i in 0...puzzMain.rowAmount)
		{
			if (columnArray[column1].mainArray[i] == _piece1)
			{
				row1 = i;
			}
			
			if (columnArray[column2].mainArray[i] == _piece2)
			{
				row2 = i;
			}
		}				
		
		temp_x = _piece1.x;
		temp_y = _piece1.y;
		
		var movespeed:Float = .2;
		
		var tween1:FlxTween = FlxTween.linearMotion(_piece1, _piece1.x, _piece1.y, _piece2.x, _piece2.y, movespeed, true, { complete: quickCheck } );
		tween1.userData = _piece1;		
		
		temp_rowassignment = _piece1.rowAssignment;
		
		_piece1.rowAssignment = _piece2.rowAssignment;
		
		_piece2.rowAssignment = temp_rowassignment;
		
		var tween2:FlxTween = FlxTween.linearMotion(_piece2, _piece2.x, _piece2.y, _piece1.x, _piece1.y, movespeed, true, { complete: quickCheck } );	
		tween2.userData = _piece2;
		
		columnArray[column1].mainArray[row1] = _piece2;
		columnArray[column2].mainArray[row2] = _piece1;			
		
		var endTween:FlxTween = FlxTween.num(1, 10, movespeed + .01, { complete: tradePlacesTween } );	
	}
	
	private function quickCheck(t:FlxTween):Void
	{
		//trace("I ended up at " + t.userData.x + " " + t.userData.y);
	}
	
	
	// If a match check fails, this animates to show the failure.
	private function tradePlacesFail(_piece1:PuzzlePiece, _piece2:PuzzlePiece):Void
	{		
		moving = true;
		
		var temp_x:Float = _piece1.x;
		var temp_y:Float = _piece1.y;
		
		var temp_x2:Float = _piece2.x;
		var temp_y2:Float = _piece2.y;
		
		var tween1:FlxTween = FlxTween.linearPath(_piece1, [new FlxPoint(_piece1.x, _piece1.y), new FlxPoint(_piece2.x, _piece2.y), new FlxPoint(temp_x, temp_y)], .2);
		var tween2:FlxTween = FlxTween.linearPath(_piece2, [new FlxPoint(_piece2.x, _piece2.y), new FlxPoint(temp_x, temp_y), new FlxPoint(temp_x2, temp_y2)], .2);
		
		var failTween:FlxTween = FlxTween.num(1, 10, .21, { complete: tradePlacesFailResult } );
	}
	
	private function tradePlacesFailResult(t:FlxTween):Void
	{
		moving = false;
	}
	
	//When a successful match is finished tweening, this handles all their removals.
	private function tradePlacesTween(t:FlxTween):Void
	{
		moving = false;
		
		onFinalComplete();		
	}
	
	/* The initial function which checks to see if A) the motion of the mouse/finger is dragging across an actual row, and B) if there's a match between either the moving piece
	 * or the moved piece. Matchverify is used to determine this completely.
	 */
	private function checkPiece(_direction:Direction):Void
	{
		var rowNum:Int = -1;
		var columnNum:Int = -1;		
		var moveable:Bool = false;
		
		var puzzlepiece1:PuzzlePiece;
		var puzzlepiece2:PuzzlePiece;
		
		for (i in 0...columnArray.length)
		{
			for (r in 0...columnArray[i].mainArray.length)
			{
				if (columnArray[i].mainArray[r] == pieceTarget)
				{
					columnNum = i;
					rowNum = r;
				}
			}
		}		
		
		switch (_direction)
		{					
			case UP:
				if (rowNum - 1 < 0)
				{
					return;
				}
				
				puzzlepiece1 = columnArray[columnNum].mainArray[rowNum];
				puzzlepiece2 = columnArray[columnNum].mainArray[rowNum - 1];
				
				if (matchVerify(puzzlepiece1, columnNum, rowNum - 1, UP) || matchVerify(puzzlepiece2, columnNum, rowNum, DOWN))
				{
					moveable = true;
				}
				
				
			case DOWN:
				if (rowNum + 1 == puzzMain.rowAmount)
				{
					return;
				}
				
				puzzlepiece1 = columnArray[columnNum].mainArray[rowNum];
				puzzlepiece2 = columnArray[columnNum].mainArray[rowNum + 1];
				
				if (matchVerify(puzzlepiece1, columnNum, rowNum + 1, DOWN) || matchVerify(puzzlepiece2, columnNum, rowNum, UP))
				{
					moveable = true;
				}
			
				
			case LEFT:
				if (columnNum - 1 < 0)
				{
					return;
				}
				
				puzzlepiece1 = columnArray[columnNum].mainArray[rowNum];
				puzzlepiece2 = columnArray[columnNum - 1].mainArray[rowNum];
				
				if (matchVerify(puzzlepiece1, columnNum - 1, rowNum, LEFT) || matchVerify(puzzlepiece2, columnNum, rowNum, RIGHT))
				{
					moveable = true;
				}
				
			case RIGHT:
				if (columnNum + 1 == puzzMain.columnAmount)
				{
					return;
				}
				
				puzzlepiece1 = columnArray[columnNum].mainArray[rowNum];
				puzzlepiece2 = columnArray[columnNum + 1].mainArray[rowNum];
				
				if (matchVerify(puzzlepiece1, columnNum + 1, rowNum, RIGHT) || matchVerify(puzzlepiece2, columnNum, rowNum, LEFT))
				{
					moveable = true;
				}
				
			case MIDDLEH:
				throw "Don't use this here.";
				
			case MIDDLEV:
				throw "Don't use this here.";
				
		}
		
		if (moveable == true)
		{
			//trace("It was moveable.");
			tradePlaces(puzzlepiece1, puzzlepiece2);
		}
		else
		{
			//trace("It was not moveable.");
			tradePlacesFail(puzzlepiece1, puzzlepiece2);
		}		
	}
	
	/*
	 * This function uses an initial _direction command to generate an _array with 4 corresponding directions included in it to process throw. The first one to 'succeed' returns true.
	 * Otherwise, it returns false.
	 * 
	 * Use by sending the piece, which column and row you want to check relative to, and what initial direction to use.
	 */
	private function matchVerify(_piece:PuzzlePiece, _column:Int, _row:Int, ?_direction:Direction, ?_array:Array<Direction>):Bool
	{
		var direction:Direction;
		
		var column:Int = _column;
		var row:Int = _row;
		var piece:PuzzlePiece = _piece;
		
		if (_direction != null)
		{
			var directionArray:Array<Direction> = new Array();
			
			switch(_direction)
			{
				case UP:
					directionArray = [UP, LEFT, RIGHT, MIDDLEH];
					
				case DOWN:
					directionArray = [DOWN, LEFT, RIGHT, MIDDLEH];
					
				case LEFT:
					directionArray = [UP, DOWN, LEFT, MIDDLEV];
					
				case RIGHT:	
					directionArray = [UP, DOWN, RIGHT, MIDDLEV];
					
				case MIDDLEH:
					throw "Don't use middleH here.";
					
				case MIDDLEV:					
					throw "Don't use middleV here.";
			}
			
			return matchVerify(_piece, _column, _row, null, directionArray);			
		}		
		
		if (_array != null && _array.length > 0)
		{
			direction = _array.shift();
			var matchArray:Array<PuzzlePiece> = new Array();
			var totalMatch:Int = 1;								
			
			switch (direction)
			{
				case UP:
					for (i in 1...3)
					{
						if (columnArray[column] != null && columnArray[column].mainArray[row - i] != null && columnArray[column].mainArray[row - i].name == piece.name)
						{
							matchArray.push(columnArray[column].mainArray[row - i]);
							totalMatch += 1;								
						}					
					
						if (totalMatch >= 3)
						{
							for (i in 0...matchArray.length)
							{
								//matchArray[i].alpha = .2;
							}
							matchArray = null;
							return true;
						}
					}
					
				case DOWN:
					for (i in 1...3)
					{
						if (columnArray[column] != null && columnArray[column].mainArray[row + i] != null && columnArray[column].mainArray[row + i].name == piece.name)
						{
							matchArray.push(columnArray[column].mainArray[row + i]);
							totalMatch += 1;								
						}					
					
						if (totalMatch >= 3)
						{
							for (i in 0...matchArray.length)
							{
								//matchArray[i].alpha = .2;
							}
							matchArray = null;
							return true;
						}
					}
					
					
				case LEFT:
					for (i in 1...3)
					{
						if (columnArray[column - i] != null && columnArray[column - i].mainArray[row] != null && columnArray[column - i].mainArray[row].name == piece.name)
						{
							matchArray.push(columnArray[column - i].mainArray[row]);
							totalMatch += 1;
						}
						
						if (totalMatch >= 3)
						{
							for (i in 0...matchArray.length)
							{
								//matchArray[i].alpha = .2;
							}
							matchArray = null;
							return true;
						}
					}
					
				case RIGHT:
					for (i in 1...3)
					{
						if (columnArray[column + i] != null && columnArray[column + i].mainArray[row] != null && columnArray[column + i].mainArray[row].name == piece.name)
						{
							matchArray.push(columnArray[column + i].mainArray[row]);
							totalMatch += 1;
						}
						
						if (totalMatch >= 3)
						{
							for (i in 0...matchArray.length)
							{
								//matchArray[i].alpha = .2;
							}
							matchArray = null;
							return true;
						}
					}
					
				case MIDDLEH:
					for (i in 0...3)
					{
						if (i == 1)
						{
							continue;
						}
					
						if (columnArray[column - 1 + i] != null && columnArray[column - 1 + i].mainArray[row] != null && columnArray[column - 1 + i].mainArray[row].name == piece.name)
						{
							matchArray.push(columnArray[column - 1 + i].mainArray[row]);
							totalMatch += 1;							
						}
					
						if (totalMatch >= 3)
						{
							for (i in 0...matchArray.length)
							{
								//matchArray[i].alpha = .2;
							}		
							matchArray = null;
							return true;
						}										
					}			
					
				case MIDDLEV:													
					for (i in 0...3)
					{
						if (i == 1)
						{
							continue;
						}
					
						if (columnArray[column] != null && columnArray[column].mainArray[row - 1 + i] != null && columnArray[column].mainArray[row - 1 + i].name == piece.name)
						{
							matchArray.push(columnArray[column].mainArray[row - 1 + i]);
							totalMatch += 1;							
						}
					
						if (totalMatch >= 3)
						{
							for (i in 0...matchArray.length)
							{
								//matchArray[i].alpha = .2;
							}		
							matchArray = null;
							return true;
						}										
					}	
				}
				
				matchArray = null;
		}
		
		if (_array != null && _array.length > 0)
		{
			return matchVerify(piece, column, row, null, _array);
		}		
		
		return false;
	}
	
	override public function flush():Void
	{
		super.flush();		
		
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		mousePoint = null;
		columnArray = null;
		puzzMain = null;
		pieceTarget = null;
		columnTarget = null;		
	}
	
}

enum Direction
{
	LEFT;
	RIGHT;
	UP;
	DOWN;
	MIDDLEH;
	MIDDLEV;
}