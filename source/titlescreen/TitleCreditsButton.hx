package titlescreen;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class TitleCreditsButton extends TitlePiece
{
	private var optionsArray:Array<FlxObject>;
	
	private var awaitingOrder:Bool = false;
	
	private var moveSpeed:Float = .5;

	public function new(_title:TitleMenu) 
	{
		super(_title);
		
		init("Credits");
	}
	
	override public function init(_name:String):Void 
	{
		super.init(_name);
		
		if (optionsArray != null)
		{
			return;
		}
		
		optionsArray = new Array();
		
		var sprite:FlxSprite = new FlxSprite();
		sprite.makeGraphic(Std.int(FlxG.width / 2), Std.int(FlxG.height / 2), 0xff333333);
		
		FlxSpriteUtil.screenCenter(sprite);
		
		optionsArray.push(sprite);
		
		var optionsText:FlxText = new FlxText(0, 0, Std.int(sprite.width), "", 14);
		optionsText.x = sprite.x;
		optionsText.y = sprite.y;
		optionsText.text = "This is just a placeholder skeleton for when I actually eventually add the credits. Just click to get it offscreen for now.";
		
		optionsArray.push(optionsText);
		
		for (i in 0...optionsArray.length)
		{
			optionsArray[i].x += FlxG.width;			
		}				
	}
	
	override public function begin():Void 
	{
		super.begin();
		
		for (i in 0...optionsArray.length)
		{
			var offset:Float = FlxG.width / 2 - optionsArray[0].width / 2;
			
			add(optionsArray[i]);
			
			if (i == 0)
			{
				var tween:FlxTween = FlxTween.linearMotion(optionsArray[i], optionsArray[i].x, optionsArray[i].y, offset, optionsArray[i].y, moveSpeed);
			}
			else
			{
				var tween:FlxTween = FlxTween.linearMotion(optionsArray[i], optionsArray[i].x, optionsArray[i].y, offset - (optionsArray[i].x - optionsArray[i].x), optionsArray[i].y, moveSpeed);
			}
		}
		
		var t:FlxTween = FlxTween.num(1, 10, moveSpeed + .1, { complete: midway } );
	}
	
	private function midway(t:FlxTween):Void
	{
		awaitingOrder = true;
	}
	
	override public function update():Void 
	{
		super.update();
		
		if (FlxG.mouse.justPressed && awaitingOrder == true)
		{
			awaitingOrder = false;
			
			for (i in 0...optionsArray.length)
			{
				var tween:FlxTween = FlxTween.linearMotion(optionsArray[i], optionsArray[i].x, optionsArray[i].y, optionsArray[i].x - FlxG.width, optionsArray[i].y, moveSpeed);
			}
			
			var t:FlxTween = FlxTween.num(1, 10, moveSpeed + .1, { complete: onFinalComplete } );			
		}
	}
	
	override public function onFinalComplete(t:FlxTween = null):Void 
	{
		super.onFinalComplete(t);				
		
		for (i in 0...optionsArray.length)
		{
			remove(optionsArray[i]);						
		}
	}
	
}