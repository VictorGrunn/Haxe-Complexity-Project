package puzzlebase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import puzzlebase.animator.PieceAnimator;
import puzzlebase.PuzzlePiece.Color;
import source.AssetsRegistry;

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
	public var colorType:Color;	
	
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
		
		colorType = _color;
		
		matchedHorizontal = false;
		matchedVertical = false;		
		x = -100;
		animType = null;
		alpha = 1;
		exists = true;
		set_scale(new FlxPoint(1, 1));
		
		rowAssignment = _row;
		
		//This is why we have a memory leak.
		//makeGraphic(pieceSize, pieceSize, 0xffffffff, true);
		//makeGraphic(pieceSize, pieceSize, 0xffffffff);
		
		switch (_color)
		{
			case Red:
				//stamp(AssetsRegistry.redStamp, 2, 2);
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballRed.png");
				name = "Red";
				
			case Blue:
				//stamp(AssetsRegistry.blueStamp, 2, 2);
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballBlue.png");
				name = "Blue";
				
			case Green:				
				//stamp(AssetsRegistry.greenStamp, 2, 2);
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballGreen.png");
				name = "Green";
				
			case Black:
				//stamp(AssetsRegistry.blackStamp, 2, 2);
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballBlack.png");
				name = "Black";
				
			case Purple:
				//stamp(AssetsRegistry.purpleStamp, 2, 2);
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballPurple.png");
				name = "Purple";
				
			case Yellow:
				//stamp(AssetsRegistry.yellowStamp, 2, 2);
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballYellow.png");
				name = "Yellow";
				
/*			case Orange:
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballOrange.png");
				name = "Orange";
				
			case Zebra:
				loadImageFromTexture(AssetsRegistry.ballsSprites, false, false, "ballZebra.png");
				name = "Zebra";			*/					
		}		
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.mouse.justPressed && GrunnUtil.overlapCheck(this))
		{			
			//trace("You clicked a " +  name);			
			
			var rowLoc:Int = 0;
			var colLoc:Int = 0;
			
			for (i in 0...Reg.puzzleMain.columnArray.length)
			{
				for (o in 0...Reg.puzzleMain.columnArray[i].mainArray.length)
				{
					if (Reg.puzzleMain.columnArray[i].mainArray[o] == this)
					{
						//trace("I am in column " + i + " row " + o + "!");						
					}									
				}								
			}
			
			for (w in 0...Reg.puzzleMain.columnArray.length)
			{
				if (rowAssignment == Reg.puzzleMain.columnArray[w])
				{
					//trace("I am assigned to column " + w);
				}
			}						
			
			
			//Reg.puzzleMain.setPieceTarget(this, rowAssignment);		
			//alpha = .5;
		}
		
		if (FlxG.mouse.justReleased)
		{
			//alpha = 1;
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
/*	Orange;
	Zebra;*/
}