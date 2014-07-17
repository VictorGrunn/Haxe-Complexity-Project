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
class ClearHorizontalSpecial extends DefaultSpecialProcess
{
	private var tweenArray:Array<FlxTween>;	
	private var puzzMain:PuzzMain;
	private var columnArray:Array<PuzzleRow>;	
	private var elimRow:Int;		

	public function new(_whichRow:Int) 
	{
		super();
		
		elimRow = _whichRow;
		
		columnArray = Reg.puzzleMain.columnArray;
		
		if (elimRow > columnArray.length)
		{
			throw "Too high of a row!";
		}				
	}
	
	override public function begin():Void 
	{
		super.begin();
		
		var pieceRemove:PieceRemoveProcess = new PieceRemoveProcess();
		
		for (i in 0...columnArray.length)
		{
			pieceRemove.addPiece(columnArray[i].mainArray[elimRow]);
		}
		
		Reg.puzzleMain.rules.addToQueue(pieceRemove);
		
		onFinalComplete();
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void 
	{
		super.onFinalComplete(t);
	}
	
}