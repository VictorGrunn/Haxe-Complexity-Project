package;

import fightgame.FightScreen;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import hud.RoundTimer;
import hud.ScoreBoard;
import puzzlebase.PuzzleRow;
import puzzlebase.PuzzMain;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	private var fightGroup:FlxTypedGroup<FightScreen>;
	public var textGroup:FlxTypedGroup<FlxText>;
	 
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		super.create();
		
		fightGroup = new FlxTypedGroup<FightScreen>();		
		textGroup = new FlxTypedGroup<FlxText>();
		
		Reg.init();
		
		Reg.menuState = this;
		
		Reg.scoreboard = new ScoreBoard();
		
		Reg.roundTimer = new RoundTimer();
		
		Reg.puzzleMain = new PuzzMain();
		add(Reg.puzzleMain);		
		
		add(Reg.scoreboard);
		
		add(Reg.roundTimer);				
		
		FlxG.autoPause = false;
		
		//add(fightGroup);		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	public function launchFightScreen():Void
	{
		var f:FightScreen = fightGroup.recycle(FightScreen);
		f.launch();
		trace("Launched a fight screen.");
		//Reg.fightScreen = new FightScreen();		
	}
	
	public function destroyFightScreen():Void
	{
		Reg.roundTimer.reset();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (Reg.roundTimer.timeOut == true)
		{
			Reg.roundTimer.update();
			fightGroup.update();			
			return;
		}
		
		super.update();		
		
		if (FlxG.keyboard.justPressed("R"))
		{
			FlxG.switchState(new MenuState());
		}
	}		
}