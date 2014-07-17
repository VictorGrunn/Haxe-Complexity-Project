package hud;
import fightgame.FightScreen;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Victor Grunn
 */
class RoundTimer extends FlxGroup
{
	private var currentTime:Int = 0;
	private var startTime:Int = 50000;
	private var roundTimer:FlxTimer;
	private var displayTime:FlxText;
	
	public var timeOut:Bool = false;

	public function new() 
	{
		super();
		
		currentTime = startTime;		
		displayTime = new FlxText(0, 0, FlxG.width, "TIME: " + currentTime, 20);
		displayTime.alignment = "center";
		roundTimer = FlxTimer.start(1, timerTick);
		add(displayTime);
	}
	
	private function timerTick(t:FlxTimer):Void
	{
		currentTime -= 1;
		displayTime.text = "TIME: " + currentTime;
		
		if (currentTime > 0)
		{
			roundTimer = FlxTimer.start(1, timerTick);
		}
		else
		{
			timeOut = true;
			Reg.menuState.launchFightScreen();
		}	
	}		
	
	public function reset():Void
	{
		timeOut = false;						
		currentTime = startTime;
		displayTime.text = "TIME: " + currentTime;
		roundTimer = FlxTimer.start(1, timerTick);
	}
	
	override public function update():Void
	{
		super.update();		
	}
	
	
}