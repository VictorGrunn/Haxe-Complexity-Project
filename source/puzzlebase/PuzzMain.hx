package puzzlebase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import puzzlebase.animator.PieceAnimator;
import puzzlebase.combatgame.MainScreen;
import puzzlebase.puzzprocess.MatchCheckProcess;
import puzzlebase.puzzprocess.RefillRowsProcess;
import puzzlebase.puzzprocess.SolutionCheckProcess;
import puzzlebase.rules.StandardRules;
import source.puzzlebase.puzzprocess.EraseBoardProcess;
import source.puzzlebase.puzzprocess.PuzzleInitializeProcess;
import puzzlebase.combatgame.backgrounds.BackgroundTemplate;
import puzzlebase.combatgame.backgrounds.ChurchBackground;
import puzzlebase.combatgame.player.PlayerTemplate;
import puzzlebase.combatgame.monsters.MonsterTemplate;
import puzzlebase.combatgame.PlayerHPBar;
import puzzlebase.combatgame.monsters.Goblin;
import puzzlebase.combatgame.player.WarriorPlayer;
import flixel.FlxCamera;

/**
 * ...
 * @author Victor Grunn
 */
class PuzzMain extends FlxGroup
{
	public var columnArray:Array<PuzzleRow>;
	
	public var columnAmount:Int = 8;
	public var rowAmount:Int = 8;
	
	public var spaceBuffer:Int;
	public var startpoint:FlxPoint;	
	
	public var refillSpeed:Int = 500;
	
	public var rules:StandardRules;	
	
	public var fightScreen:MainScreen;
	
	public var background:BackgroundTemplate;
	public var player:PlayerTemplate;
	public var monster:MonsterTemplate;	
	public var encounterArray:Array<MonsterTemplate>;
	
	public var playerHP:PlayerHPBar;	
	
	private var fightCam:FlxCamera;	
	
	// Generates the initial puzzle size, including space between each symbol, where the puzzle starts at, and so on.
	public function new() 
	{
		super();		
		
		encounterArray = new Array();
		encounterArray = [new Goblin(), new Goblin(), new Goblin(), new Goblin()];
		
		var offsetX:Int = Std.int((FlxG.width / 2) - (columnAmount * (30 + spaceBuffer)) / 2);
		var offsetY:Int = Std.int(FlxG.height - ((rowAmount + 1)  * (30 + spaceBuffer)));
		
		columnArray = new Array();
		
		startpoint = new FlxPoint(offsetX, offsetY);
		
		spaceBuffer = 2;
		
		for (i in 0...columnAmount)
		{
			var puzzlrow:PuzzleRow = new PuzzleRow(new FlxPoint(startpoint.x + (i * PuzzlePiece.pieceSize) + (i * spaceBuffer), startpoint.y), rowAmount, spaceBuffer, this);
			columnArray.push(puzzlrow);
			add(puzzlrow);
		}		
		
		//FlxG.watch.add(this, "orderQueue", "OQ: ");		
		
		rules = new StandardRules();
		add(rules);				
		
		var initialize:PuzzleInitializeProcess = new PuzzleInitializeProcess(this);
		rules.addToQueue(initialize);
		
		FlxG.watch.add(rules, "ruleQueue", "Queue: ");
		FlxG.watch.add(rules.ruleQueue, "length", "Queue Length: ");	
		
		setupFightScreen();
	}			
	
	private function setupFightScreen():Void
	{
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
		
		var zoomNum:Float = 1.75;
		
		fightCam = new FlxCamera(1, 1, Std.int(background.width), Std.int(background.height), zoomNum);
		fightCam.x = (FlxG.width / 2) - ((fightCam.width * zoomNum) / 2);
		fightCam.y = 30; 		
		
		fightCam.bgColor = 0x00000000;
		
		FlxG.cameras.add(fightCam);
		
		fightCam.focusOn(new FlxPoint(background.x + background.width / 2, background.y + background.height / 2));
		
		background.alpha = 0;
		
		var tween1:FlxTween = FlxTween.multiVar(background, { alpha: 1 }, 10);
		
		playerHP = new PlayerHPBar(fightCam, player, zoomNum);		
		add(playerHP);
	}
	
	override public function update():Void
	{
		//super.update();
		
		//movePiece();
		
		rules.update();
		
		playerHP.update();
		
		fightCam.update();
		
		for (i in 0...columnArray.length)
		{
			columnArray[i].update();
		}
				
		if (FlxG.keys.justPressed.Y)
		{
			FlxG.watch.remove(rules, "ruleQueue");
			FlxG.watch.remove(rules.ruleQueue, "length");			
			var eraseBoard:EraseBoardProcess = new EraseBoardProcess(Reg.puzzleMain);
			rules.addOverrideToQueue(eraseBoard);
			
			FlxG.watch.add(rules, "ruleQueue", "Queue: ");
			FlxG.watch.add(rules.ruleQueue, "length", "Queue Length: ");
		}				
	}		
	
	override public function destroy():Void
	{
		rules.destroy();				
		
		super.destroy();		
	}
}