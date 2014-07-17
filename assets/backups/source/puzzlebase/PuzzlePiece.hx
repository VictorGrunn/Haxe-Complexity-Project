package puzzlebase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import puzzlebase.animator.PieceAnimator;

/**
 * ...
 * @author Victor Grunn
 */
class PuzzlePiece extends FlxSprite
{
	public var name:String = "";
	public var rowAssignment:PuzzleRow;
	public var destinationPoint:FlxPoint;
	public var startingPoint:FlxPoint;
	public var animType:AnimationType;
	public var matchedHorizontal:Bool = false;
	public var matchedVertical:Bool = false;
	
	public static var pieceSize:Int = 30;	

	public function new() 
	{		
		exists = false;
		destinationPoint = new FlxPoint();
		startingPoint = new FlxPoint();
		super();				
	}	
	
	/*
	 * The setup for the puzzle piece. Sets the color, sets it to existing, assigns it a PuzzleRow for reference.
	 */ 
	public function launch(_color:Color = null, _row:PuzzleRow):Void
	{								
		if (_color == null)
		{
			var c:Array<Color> = new Array();
			c = [Red, Blue, Black, Green, Purple, Yellow];
			_color = c[FlxRandom.intRanged(0, c.length - 1)];
			c = null;
		}
		
		matchedHorizontal = false;
		matchedVertical = false;		
		x = -100;
		animType = null;
		alpha = 1;
		exists = true;
		set_scale(new FlxPoint(1, 1));
		
		rowAssignment = _row;
		
		var stampSprite:FlxSprite = new FlxSprite();
		
		switch (_color)
		{
			case Red:
				stampSprite.makeGraphic(pieceSize - 4, pieceSize - 4, 0xffff0000);
				name = "Red";
				
			case Blue:
				stampSprite.makeGraphic(pieceSize - 4, pieceSize - 4, 0xff00ff00);
				name = "Green";
				
			case Green:				
				stampSprite.makeGraphic(pieceSize - 4, pieceSize - 4, 0xff0000ff);
				name = "Blue";
				
			case Black:
				stampSprite.makeGraphic(pieceSize - 4, pieceSize - 4, 0xff222222);
				name = "Black";
				
			case Purple:
				stampSprite.makeGraphic(pieceSize - 4, pieceSize - 4, 0xffcc00ff);
				name = "Purple";
				
			case Yellow:
				stampSprite.makeGraphic(pieceSize - 4, pieceSize - 4, 0xffffff00);
				name = "Yellow";
				
		}
		
		makeGraphic(pieceSize, pieceSize, 0xffffffff, true);
		stamp(stampSprite, 2, 2);
		
		stampSprite.destroy();	
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.mouse.justPressed && GrunnUtil.overlapCheck(this))
		{			
			trace("You clicked a " +  name);
			
			var rowLoc:Int = 0;
			var colLoc:Int = 0;
			
			for (i in 0...Reg.puzzleMain.columnArray.length)
			{
				for (o in 0...Reg.puzzleMain.columnArray[i].mainArray.length)
				{
					if (Reg.puzzleMain.columnArray[i].mainArray[o] == this)
					{
						trace("I am in column " + i + " row " + o + "!");						
					}
				}
			}
			
			Reg.puzzleMain.setPieceTarget(this, rowAssignment);		
			alpha = .5;
		}
		
		if (FlxG.mouse.justReleased)
		{
			alpha = 1;
		}
	}
	
}

enum Color
{
	Red;
	Green;
	Blue;
	Purple;
	Yellow;
	Black;
}