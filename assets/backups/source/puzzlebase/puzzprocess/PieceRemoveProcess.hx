package puzzlebase.puzzprocess;
import flixel.tweens.FlxTween;
import puzzlebase.PuzzlePiece;
import puzzlebase.puzzprocess.PieceRemoveProcess.RemoveType;

/**
 * ...
 * @author Victor Grunn
 */
class PieceRemoveProcess extends ProcessPart
{
	private var pieceArray:Array<PuzzlePiece>;
	public var removeType:RemoveType;

	public function new() 
	{
		super();						
		
		removeType = Mixed;
	}
	
	public function checkPresent(_piece:PuzzlePiece):Bool
	{
		if (pieceArray == null)
		{
			throw "PieceArray was null.";
		}
		
		for (i in 0...pieceArray.length)
		{
			if (_piece == pieceArray[i])
			{
				return true;
			}
		}
		
		return false;
	}
	
	public function addPiece(_piece:PuzzlePiece):Void
	{
		if (pieceArray == null)
		{
			pieceArray = new Array();
		}
		
		if (checkPresent(_piece) == false)
		{
			pieceArray.push(_piece);
		}
	}
	
	public function setType(_type:RemoveType):Void
	{
		removeType = _type;
	}
	
	override public function begin():Void
	{
		if (removeType == null || pieceArray == null)
		{
			throw "Removetype or Piecearray was null";
		}
		
		
		super.begin();
		
		removePieces();
	}
	
	private function removePieces():Void
	{
		var _time:Float = .25;
		
		for (i in 0...pieceArray.length)
		{
			removePiece(pieceArray[i], _time);
		}
		
		var endTween:FlxTween = FlxTween.num(1, 10, _time + .01, { complete: onFinalComplete } );		
	}
	
	override private function onFinalComplete(t:FlxTween = null):Void
	{
		var typeText:String = "";				
		
		if (removeType == null)
		{
			throw "Nope. It was null.";
		}
		
		switch(removeType)
		{
			case Horizontal:
				typeText = "It was horizontal!";
				
			case Vertical:
				typeText = "It was vertical!";
				
			case Mixed:
				typeText = "It was mixed!";				
		}
		
		trace(typeText + " " + pieceArray.length + " " + pieceArray[0].name + " pieces!");
		
		pieceArray = null;
		removeType = null;
		//Reg.puzzleMain.checkRows();
		
		super.onFinalComplete(t);
	}
	
	public function removePiece(t:PuzzlePiece, _time:Float):Void
	{		
		var tween:FlxTween = FlxTween.multiVar(t.scale, { x: .1, y: .1 }, _time, { complete: removePieceTween } );
		tween.userData = t;								
	}
	
	private function removePieceTween(t:FlxTween):Void
	{
		t.userData.x = -100;
		t.userData.x = 0;
		t.userData.exists = false;		
		
		for (i in 0...t.userData.rowAssignment.mainArray.length)
		{
			if (t.userData.rowAssignment.mainArray[i] == t.userData)
			{
				t.userData.rowAssignment.mainArray[i] = null;				
				break;								
			}
		}		
	}		
	
	
	
}

enum RemoveType
{
	Horizontal;
	Vertical;
	Mixed;
}