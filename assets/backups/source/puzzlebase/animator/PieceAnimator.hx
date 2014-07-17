package puzzlebase.animator;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import puzzlebase.PuzzlePiece;

/**
 * ...
 * @author Victor Grunn
 */
class PieceAnimator
{
	public static var animationsInProcess:Int = 0;

	public function new() 
	{
		
	}
	
	public static function animate(?_array:Array<PuzzlePiece>, ?_piece:PuzzlePiece):Void
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
	
	private static function animateHelper(_piece:PuzzlePiece):Void
	{
		animationsInProcess += 1;
		
		switch (_piece.animType)
		{
			case DropDown:
				var tween:FlxTween = FlxTween.linearMotion(_piece, _piece.startingPoint.x, _piece.startingPoint.y, _piece.destinationPoint.x, _piece.destinationPoint.y, Reg.puzzleMain.refillSpeed, false, {complete: onComplete});	
				
			case ScatterIn:
				var tween:FlxTween = FlxTween.cubicMotion(_piece, _piece.startingPoint.x, _piece.startingPoint.y, FlxRandom.floatRanged(0, FlxG.width), FlxRandom.floatRanged(0, FlxG.height), 
			FlxRandom.floatRanged(0, FlxG.width), FlxRandom.floatRanged(0, FlxG.height), _piece.destinationPoint.x, _piece.destinationPoint.y, 1, { complete: onComplete });
				
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
				
				var tween:FlxTween = FlxTween.linearMotion(_piece, _piece.destinationPoint.x + hChange, _piece.destinationPoint.y + vChange, _piece.destinationPoint.x, _piece.destinationPoint.y, .45, true,
				{ complete: onComplete } );
				
			case FadeIn:
				_piece.alpha = 0;
				_piece.x = _piece.destinationPoint.x;
				_piece.y = _piece.destinationPoint.y;
				_piece.scale.x = 4;
				_piece.scale.y = 4;
				var tween:FlxTween = FlxTween.multiVar(_piece.scale, { x: 1, y: 1 }, .5);
				var tween:FlxTween = FlxTween.multiVar(_piece, { alpha: 1 }, .51, { complete: onComplete } );				
		}
	}
	
	private static function onComplete(t:FlxTween):Void
	{
		animationsInProcess -= 1;			
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