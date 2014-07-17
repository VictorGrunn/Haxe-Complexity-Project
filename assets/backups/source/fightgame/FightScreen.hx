package fightgame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class FightScreen extends FlxGroup
{
	private var player:Player;
	private var zombie:Zombie;
	private var background:FlxSprite;
	
	private var spriteArray:Array<FlxSprite>;
	private var doneYet:Bool = false;
	private var processing:Bool = false;

	public function new() 
	{
		super();
		
		spriteArray = new Array();
		
		background = new FlxSprite();
		background.makeGraphic(Std.int(FlxG.width / 1.5), Std.int(FlxG.height / 1.5), 0xff333333);
		
		player = new Player();
		zombie = new Zombie();
		
		background.x = (FlxG.width / 2) - (background.width / 2);
		background.y = (FlxG.height / 2) - (background.height / 2);
		
		player.x = background.x + 5;
		player.y = background.y + background.height - player.height - 5;
		
		zombie.x = background.x + background.width - zombie.width - 5;
		zombie.y = background.y + background.height - zombie.height - 5;
		
		spriteArray.push(background);
		spriteArray.push(player);
		spriteArray.push(zombie);				
	}
	
	public function launch():Void
	{
		exists = true;
		doneYet = false;
		processing = false;
		setAll("exists", true);
		
		while (background.x < 0)
		{
			background.x += 10;
			player.x += 10;
			zombie.x += 10;
			trace("Done at " + Math.random());
		}
		
		for (i in 0...spriteArray.length)
		{
			add(spriteArray[i]);
			var tween:FlxTween = FlxTween.linearMotion(spriteArray[i], spriteArray[i].x + 1000, spriteArray[i].y, spriteArray[i].x, spriteArray[i].y, 1, true);
			
			if (i == spriteArray.length - 1)
			{				
				var durTween:FlxTween = FlxTween.num(1, 10, 2, { complete: onComplete } );
			}
		}
		
		for (i in 0...4)
		{
			var act:ActionTemplate = new ActionTemplate();
			act.setup(background);
			Reg.addToQueue(act);
		}
		
		trace("Launch ran.");
	}
	
	private function clearScreen():Void
	{
		for (i in 0...spriteArray.length)
		{
			var tween:FlxTween = FlxTween.linearMotion(spriteArray[i], spriteArray[i].x, spriteArray[i].y, spriteArray[i].x - 1000, spriteArray[i].y, 1, true);
		}
		
		var durTween:FlxTween = FlxTween.num(1, 10, 1.1, { complete: endThis } );
	}
	
	private function endThis(t:FlxTween):Void
	{
		Reg.menuState.destroyFightScreen();
		setAll("exists", false);
		exists = false;
	}
	
	override public function update():Void
	{
		super.update();
		
		if (FlxG.keyboard.justPressed("SPACE") && doneYet)
		{
			clearScreen();
		}
		
		if (Reg.fightQueue.length > 0 && processing)
		{
			if (Reg.fightQueue[0].started == false)
			{
				Reg.fightQueue[0].begin();
				add(Reg.fightQueue[0]);
			}
			
			if (Reg.fightQueue[0].complete)
			{
				remove(Reg.fightQueue[0]);
				Reg.fightQueue.shift();
			}						
		}
		else if (doneYet == false && processing)
		{
			doneYet = true;
			clearScreen();
		}
	}
	
	private function onComplete(t:FlxTween):Void
	{
		processing = true;
		
		trace("oncomplete ran.");
	}
	
	override public function destroy():Void
	{
		super.destroy();
		player = null;
		zombie = null;
		background = null;
		spriteArray = null;
	}
	
	
}