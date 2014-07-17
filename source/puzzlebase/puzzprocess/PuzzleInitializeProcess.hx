package source.puzzlebase.puzzprocess;
import puzzlebase.PuzzMain;
import puzzlebase.puzzprocess.ProcessPart;
import puzzlebase.PuzzleRow;
import puzzlebase.PuzzlePiece;
import puzzlebase.puzzprocess.RefillRowsProcess;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.FlxG;

/**
 * ...
 * @author Victor Grunn
 */
class PuzzleInitializeProcess extends ProcessPart
{
	private var puzzMain:PuzzMain;
	private var columnArray:Array<PuzzleRow>;

	public function new(_main:PuzzMain) 
	{
		super();												
		puzzMain = _main;												
		columnArray = puzzMain.columnArray;		
	}
	
	override public function begin():Void
	{
		initialPuzzle();
	}
	
	private function initialPuzzle():Void
	{
		var vName:String = "";
		var hName:String = "";
		
		if (puzzMain == null)
		{
			throw "Puzzmain was null.";
		}				
		
		if (puzzMain.columnArray == null)
		{
			throw "Columnarray was null.";
		}
		
		for (i in 0...columnArray.length)
		{
			for (o in 0...puzzMain.rowAmount)
			{				
				var piece:PuzzlePiece = columnArray[i].puzzleGroup.recycle(PuzzlePiece);
				piece.launch(null, columnArray[i]);
				
				if (columnArray[i].mainArray[o - 1] != null && columnArray[i].mainArray[o - 2] != null)
				{
					//if (columnArray[i].mainArray[o].name == columnArray[i].mainArray[o - 1].name && columnArray[i].mainArray[o - 1].name == columnArray[i].mainArray[o - 2].name)
					if (columnArray[i].mainArray[o - 1].name == columnArray[i].mainArray[o - 2].name)
					{
						vName = columnArray[i].mainArray[o - 1].name;
					}
				}
				
				if (columnArray[i - 1] != null && columnArray[i - 2] != null)
				{
					//if (columnArray[i].mainArray[o] == columnArray[i - 1].mainArray[o] && columnArray[i - 1].mainArray[o] == columnArray[i - 2].mainArray[o])
					if (columnArray[i - 1].mainArray[o].name == columnArray[i - 1].mainArray[o].name)
					{
						hName = columnArray[i - 1].mainArray[o].name;
					}
				}
				
				while (piece.name == vName || piece.name == hName)
				{
					piece.launch(null, columnArray[i]);
				}								
				
				//piece.startingPoint.x = piece.x;
				piece.startingPoint.x = puzzMain.startpoint.x + (puzzMain.columnAmount * (30 + puzzMain.spaceBuffer)) / 2;
				piece.startingPoint.y = puzzMain.startpoint.y + (puzzMain.rowAmount * (30 + puzzMain.spaceBuffer)) / 2;
				//piece.startingPoint.y = piece.y;
		
				piece.destinationPoint.x = columnArray[i].location.x;
				piece.destinationPoint.y = columnArray[i].location.y + piece.height * o + puzzMain.spaceBuffer * o;	
				//orderQueue += 1;
				//columnArray[i].addPiece(piece, o);
				addPiece(piece, o, columnArray[i]);
			}
		}
		
		
		animatePieces(columnArray);		
				
		//puzzMain = null;
		//columnArray = null;
	}
	
	public function addPiece(_piece:PuzzlePiece, _slot:Int, _column:PuzzleRow):Void
	{
		if (_slot > _column.rowSize -1)
		{
			throw "Bigger than the row.";
		}
		
		if (_column.mainArray[_slot] != null)
		{
			_column.mainArray[_slot].x = -100;
			_column.mainArray[_slot].exists = false;
			_column.mainArray[_slot] = null;
		}
		
		_column.mainArray[_slot] = _piece;
	}	
	
	private function animatePieces(_array:Array<PuzzleRow>):Void
	{
		for (i in 0..._array.length)
		{
			for (r in 0..._array[i].mainArray.length)
			{
				var tween:FlxTween = FlxTween.cubicMotion(_array[i].mainArray[r], _array[i].mainArray[r].startingPoint.x, _array[i].mainArray[r].startingPoint.y, FlxRandom.floatRanged(0, FlxG.width), FlxRandom.floatRanged(0, FlxG.height), FlxRandom.floatRanged(0, FlxG.width), FlxRandom.floatRanged(0, FlxG.height), _array[i].mainArray[r].destinationPoint.x, _array[i].mainArray[r].destinationPoint.y, .5);
			}			
		}				
		
		var tween:FlxTween = FlxTween.num(1, 10, .52, { complete: onFinalComplete } );	
	}	
	
	override public function flush():Void
	{
		super.flush();
		
		//puzzMain = null;
		//columnArray = null;
	}
}