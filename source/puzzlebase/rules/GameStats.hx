package puzzlebase.rules;
import puzzlebase.PuzzlePiece;
import puzzlebase.PuzzlePiece.Color;

/**
 * ...
 * @author Victor Grunn
 */
class GameStats
{
	public var redMatched:Int = 0;
	public var blueMatched:Int = 0;
	public var greenMatched:Int = 0;
	public var yellowMatched:Int = 0;
	public var blackMatched:Int = 0;
	public var purpleMatched:Int = 0;
	
	public var comboCount:Int = 0;
	
	public var currentCombos:Int = 0;
	
	public var biggestMatch:Int = 0;

	public function new() 
	{
		
	}
	
	public function processPieces(_array:Array<PuzzlePiece>):Void
	{		
		comboCount += 1;
		
		currentCombos += 1;
		
		if (biggestMatch < _array.length)
		{
			biggestMatch = _array.length;
		}
		
		for (i in 0..._array.length)
		{
			switch(_array[i].colorType)
			{
				case Blue:
					blueMatched += 1;
					
				case Red:
					redMatched += 1;
					
				case Green:
					greenMatched += 1;
					
				case Yellow:
					yellowMatched += 1;
					
				case Black:
					blackMatched += 1;
					
				case Purple:			
					purpleMatched += 1;
			}
		}
		
		Reg.puzzleMain.rules.updateData();
	}
	
	public function giveData():String
	{
		var s:String = "";
		s += "Red Matched: " + redMatched;
		s += "\nBlue Matched: " + blueMatched; 
		s += "\nGreen Matched: " + greenMatched;
		s += "\nYellow Matched: " + yellowMatched;
		s += "\nBlack Matched: " + blackMatched;
		s += "\nPurple Matched: " + purpleMatched;
		s += "\n\nTotal Combos: " + comboCount;
		s += "\n\nCurrent Combos: " + currentCombos;
		s += "\n\nBiggest Match: " + biggestMatch;
		return s;
	}
	
	public function resetAll():Void
	{
		redMatched = 0;
		greenMatched = 0;
		blueMatched = 0;
		yellowMatched = 0;
		blackMatched = 0;
		purpleMatched = 0;
		
		currentCombos = 0;
		
		comboCount = 0;
		
		biggestMatch = 0;
	}
	
	public function resetRound():Void
	{
		currentCombos = 0;
	}
	
}