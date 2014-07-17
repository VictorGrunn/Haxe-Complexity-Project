package puzzlebase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import puzzlebase.animator.PieceAnimator;

/**
 * ...
 * @author Victor Grunn
 */
class PuzzleRow extends FlxGroup
{	
	public var mainArray:Array<PuzzlePiece>;
	public var rowSize:Int;
	public var location:FlxPoint;
	
	public var puzzleGroup:FlxTypedGroup<PuzzlePiece>;
	
	public var spaceBuffer:Int;
	
	private var mainClass:PuzzMain;	

	//Sets everything up for row generation. Actual row generation is called from the PuzzMain class.
	public function new(_location:FlxPoint, _rowSize:Int, _spaceBuffer:Int, _mainClass:PuzzMain) 
	{
		super();			
		
		spaceBuffer = _spaceBuffer;
		
		puzzleGroup = new FlxTypedGroup<PuzzlePiece>();
		add(puzzleGroup);
		
		rowSize = _rowSize;
		
		location = _location;
		
		mainClass = _mainClass;
		
		mainArray = new Array<PuzzlePiece>();									
	}			
}