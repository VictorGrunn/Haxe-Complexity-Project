package puzzlebase.puzzprocess.specialmoves;
import flixel.tweens.FlxTween;
import puzzlebase.PuzzlePiece.Color;
import puzzlebase.PuzzMain;
import puzzlebase.PuzzleRow;
import puzzlebase.PuzzlePiece;
import puzzlebase.puzzprocess.MatchCheckProcess;
import puzzlebase.puzzprocess.PieceRemoveProcess;
import puzzlebase.puzzprocess.RefillRowsProcess;

/**
 * ...
 * @author Victor Grunn
 */
class ClearColorSpecial extends DefaultSpecialProcess
{
	private var tweenArray:Array<FlxTween>;
	private var elimColor:Color;
	private var puzzMain:PuzzMain;
	private var columnArray:Array<PuzzleRow>;	

	public function new(_puzzMain:PuzzMain, _color:Color) 
	{
		super();
		
		tweenArray = new Array();
		
		puzzMain = _puzzMain;
		columnArray = _puzzMain.columnArray;
		
		elimColor = _color;
		
		trace("Elimcolor was " + elimColor);		
	}
	
	override public function begin():Void
	{
		var pieceArray:Array<PuzzlePiece> = new Array();
		
		for (i in 0...columnArray.length)
		{
			for (o in 0...columnArray[i].mainArray.length)
			{
				if (columnArray[i].mainArray[o] != null && columnArray[i].mainArray[o].colorType == elimColor)
				{
					pieceArray.push(columnArray[i].mainArray[o]);
				}
			}
		}
		
		trace(pieceArray.length + " pieces were caught.");
		
		if (pieceArray.length > 0)
		{	
			var removePieces:PieceRemoveProcess = new PieceRemoveProcess();
			removePieces.setType(Special);
			
			for (i in 0...pieceArray.length)
			{
				removePieces.addPiece(pieceArray[i]);
			}			
			
			puzzMain.rules.addToQueue(removePieces);
			
			var refill:RefillRowsProcess = new RefillRowsProcess(puzzMain);
			puzzMain.rules.addToQueue(refill);
		}
		
		pieceArray = null;
		
		onFinalComplete();
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void 
	{
		elimColor = null;
		tweenArray = null;		
		
		super.onFinalComplete(t);
	}
	
	override public function flush():Void 
	{
		elimColor = null;
		
		for (i in 0...tweenArray.length)
		{
			tweenArray[i].cancel();
		}
		
		tweenArray = null;
		
		super.flush();
	}
	
}