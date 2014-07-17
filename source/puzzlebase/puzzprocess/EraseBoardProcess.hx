package source.puzzlebase.puzzprocess;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import puzzlebase.animator.PieceAnimator;
import puzzlebase.PuzzlePiece;
import puzzlebase.PuzzMain;
import puzzlebase.puzzprocess.ProcessPart;
import puzzlebase.puzzprocess.RefillRowsProcess;

/**
 * ...
 * @author Victor Grunn
 */
class EraseBoardProcess extends ProcessPart
{
	private var puzzMain:PuzzMain;
	private var locArray:Array<Array<Int>>;
	private var removeSpeed:Float = .15;
	private var endTween:FlxTween;

	public function new(_puzz:PuzzMain) 
	{
		super();
		
		for (i in 0...FlxTween.manager.list.length)
		{
			if (FlxTween.manager.list[i] != null)
			{
				FlxTween.manager.list[i].cancel();
				//FlxTween.manager.list[i].destroy();
			}			
		}
		
		//PieceAnimator.animationsInProcess = 0;
		
		puzzMain = _puzz;		
		locArray = new Array();
		
		for (i in 0...puzzMain.columnArray.length)
		{
			var numArray:Array<Int> = new Array();
			
			for (o in 0...puzzMain.columnArray[i].mainArray.length)
			{
				numArray.push(o);
			}
			
			locArray.push(numArray);
		}
	}
	
	override public function begin():Void
	{
		super.begin();
		
		clearBoard();
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void
	{
		trace("initialized ");
		
		var resetBoard:PuzzleInitializeProcess = new PuzzleInitializeProcess(puzzMain);
		puzzMain.rules.addToQueue(resetBoard);
		
		for (i in 0...locArray.length)
		{
			locArray[i] = null;
		}		
		
		//locArray = null;
		//puzzMain = null;
		
		endTween = null;
		
		super.onFinalComplete();
	}
	
	private function clearBoard(t:FlxTimer = null):Void	
	{				
		var areThereAnyLeft:Bool = false;
		
		for (i in 0...locArray.length)
		{
			if (locArray[i].length > 0)
			{
				areThereAnyLeft = true;
				break;
			}
		}
		
		if (areThereAnyLeft == false)
		{			
			//This is a little sloppy. Without the class tween, this will run twice.
			if (endTween == null)
			{
				endTween = FlxTween.num(1, 10, removeSpeed + .03, { complete: onFinalComplete } );
			}			
			return;
		}
		
		var colNum:Int = 666;
		var rowNum:Int = 666;
		
		while (colNum == 666)
		{
			var checkNum:Int = Math.floor(Math.random() * locArray.length);
			
			if (locArray[checkNum].length > 0)
			{
				colNum = checkNum;
			}
		}
		
		while (rowNum == 666)
		{
			rowNum = Math.floor(Math.random() * locArray[colNum].length);
		}
		
		var pieceRowNum:Int = locArray[colNum][rowNum];
		
		var movingPiece:PuzzlePiece = puzzMain.columnArray[colNum].mainArray[pieceRowNum];
		
		locArray[colNum].remove(locArray[colNum][rowNum]);
		
		var timer:FlxTimer = FlxTimer.start(.01, clearBoard);
		
		if (movingPiece == null)
		{
			return;			
		}				
		
		var alphaTween:FlxTween = FlxTween.multiVar(movingPiece, { alpha: 0 }, removeSpeed);
		var tween:FlxTween = FlxTween.linearMotion(movingPiece, movingPiece.x, movingPiece.y, FlxG.width, movingPiece.y, removeSpeed, true, { complete: removePiece } );		
		tween.userData = movingPiece;					
	}
	
	private function removePiece(t:FlxTween):Void
	{
		for (i in 0...puzzMain.columnArray.length)
		{
			for (o in 0...puzzMain.columnArray[i].mainArray.length)
			{
				if (puzzMain.columnArray[i].mainArray[o] == t.userData)
				{
					puzzMain.columnArray[i].mainArray[o] = null;
					t.userData.exists = false;
				}
			}
		}
	}
	
	override public function flush():Void
	{
		super.flush();
		//puzzMain = null;
		//locArray = null;
	}
	
}