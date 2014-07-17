package puzzlebase.puzzprocess;
import flixel.text.FlxText;
import puzzlebase.PuzzlePiece;
import flixel.tweens.FlxTween;
import puzzlebase.PuzzleRow;
import flixel.util.FlxPoint;
import flixel.FlxG;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class ComputerMoveProcess extends ProcessPart
{
	private var piece1:PuzzlePiece;
	private var piece2:PuzzlePiece;
	private var columnArray:Array<PuzzleRow>;
	private var tweenArray:Array<FlxTween>;
	
	//private var testText:FlxText;

	public function new(_piece1:PuzzlePiece, _piece2:PuzzlePiece) 
	{
		super();	
		piece1 = _piece1;
		piece2 = _piece2;		
		
		tweenArray = new Array();
		
		columnArray = Reg.puzzleMain.columnArray;
		
		/*//testText = new FlxText(0, FlxG.height - 100, FlxG.width, "MOVING PIECE");
		testText = AssetsRegistry.masterTextGroup.recycle(FlxText, [0, FlxG.height - 100, FlxG.width, "MOVING PIECE"]);
		testText.exists = true;
		testText.setFormat(null, 20, 0xffffff, "center");
		add(testText);*/
		
		Reg.puzzleMain.rules.gameStats.resetRound();
	}
	
	override public function begin():Void
	{
		super.begin();				
		
		tradePlaces(piece1, piece2);				
	}	
	
	override private function onFinalComplete(t:FlxTween = null):Void
	{
		columnArray = null;
		tweenArray = null;
		
		/*remove(testText);
		testText.exists = false;*/
		
		super.onFinalComplete(t);
	}
	
	private function tradePlaces(_piece1:PuzzlePiece, _piece2:PuzzlePiece):Void
	{
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
		
		for (i in 0...Reg.puzzleMain.rowAmount)
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
		
		var tween1:FlxTween = FlxTween.linearMotion(_piece1, _piece1.x, _piece1.y, _piece2.x, _piece2.y, movespeed);
		
		temp_rowassignment = _piece1.rowAssignment;
		
		_piece1.rowAssignment = _piece2.rowAssignment;
		
		_piece2.rowAssignment = temp_rowassignment;
		
		var tween2:FlxTween = FlxTween.linearMotion(_piece2, _piece2.x, _piece2.y, _piece1.x, _piece1.y, movespeed);
		
		columnArray[column1].mainArray[row1] = _piece2;
		columnArray[column2].mainArray[row2] = _piece1;			
		
		var endTween:FlxTween = FlxTween.num(1, 10, movespeed + .01, { complete: tradePlacesTween } );				
		
		tweenArray.push(tween1);
		tweenArray.push(tween2);
		tweenArray.push(endTween);
	}		
	
	//When a successful match is finished tweening, this handles all their removals.
	private function tradePlacesTween(t:FlxTween):Void
	{				
		var newProcess:MatchCheckProcess = new MatchCheckProcess(Reg.puzzleMain);
		Reg.puzzleMain.rules.addToQueue(newProcess);		
		onFinalComplete();
	}
	
	override public function flush():Void
	{
		super.flush();
		
		for (i in 0...tweenArray.length)
		{
			tweenArray[i].cancel();
		}
		
		tweenArray = null;
		
		piece1 = null;
		piece2 = null;
		columnArray = null;
		
		/*remove(testText);
		testText.exists = false;*/
	}
	
}