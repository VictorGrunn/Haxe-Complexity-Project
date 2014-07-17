package puzzlebase.combatgame;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import puzzlebase.combatgame.backgrounds.BackgroundTemplate;
import puzzlebase.combatgame.backgrounds.ChurchBackground;
import puzzlebase.combatgame.monsters.Goblin;
import puzzlebase.combatgame.monsters.MonsterTemplate;
import puzzlebase.combatgame.player.PlayerTemplate;
import puzzlebase.combatgame.player.WarriorPlayer;
import puzzlebase.combatgame.orders.OrderTemplate;

/**
 * ...
 * @author Victor Grunn
 */
class MainScreen extends FlxGroup
{
	public var background:BackgroundTemplate;
	public var player:PlayerTemplate;
	public var monster:MonsterTemplate;	
	public var playerHP:PlayerHPBar;	
	private var fightCam:FlxCamera;
	
	private var orderQueue:Array<OrderTemplate>;
	
	public var processing:Bool = false;

	public function new() 
	{
		super();
		
		orderQueue = new Array();
		
		background = new ChurchBackground();
		
		player = new WarriorPlayer();
		
		monster = new Goblin();
		
		//background.x = FlxG.width - background.width;
		background.x = 5000;
		background.y = FlxG.height - background.height;
		
		player.x = background.x + 10;
		player.y = background.y + background.height - player.height - 25;
		
		monster.x = background.x + background.width - monster.width - 10;
		monster.y = background.y + background.height - monster.height - 25;
		
		add(background);
		
		add(player);
		
		add(monster);
		
		var zoomNum:Float = 1.5;
		
		fightCam = new FlxCamera(1, 1, Std.int(background.width), Std.int(background.height), zoomNum);
		fightCam.x = FlxG.width - (fightCam.width * zoomNum);
		fightCam.y = FlxG.height - (fightCam.height * zoomNum) - 10; 
		
		fightCam.bgColor = 0x00000000;				
		
		FlxG.cameras.add(fightCam);
		
		fightCam.focusOn(new FlxPoint(background.x + background.width / 2, background.y + background.height / 2));
		
		background.alpha = 0;
		
		var tween1:FlxTween = FlxTween.multiVar(background, { alpha: 1 }, 10);
		
		playerHP = new PlayerHPBar(fightCam, player, zoomNum);		
		add(playerHP);
		
		FlxG.watch.add(this, "orderQueue", "OrderQueue: ");
	}	
	
	public function addToQueue(_order:OrderTemplate):Void
	{
		if (orderQueue.length == 0)
		{
			orderQueue.push(_order);
			orderQueue[0].begin();
		}
		else
		{
			orderQueue.push(_order);
		}
	}
	
	public function nextMove():Void
	{
		if (orderQueue[0].complete == true)
		{
			remove(orderQueue[0]);
			orderQueue.shift();
			
			if (orderQueue.length > 0)
			{
				add(orderQueue[0]);
				orderQueue[0].begin();
			}
		}
		
	}
	
}