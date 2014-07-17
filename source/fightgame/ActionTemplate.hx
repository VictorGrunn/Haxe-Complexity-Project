package fightgame;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Victor Grunn
 */
class ActionTemplate extends FlxGroup
{
	public var complete:Bool = false;
	public var started:Bool = false;
	public var actionName:String = "Default";
	
	private var actionText:FlxText;
	private var target:FlxSprite;

	public function new() 
	{
		super();
		
		//actionText = new FlxText(0, 0, FlxG.width, "", 20);
		actionText = Reg.menuState.textGroup.recycle(FlxText, [0, 0, FlxG.width]);
		actionText.alignment = "center";
		actionText.text = actionName;
	}	
	
	public function setup(_target:FlxSprite):Void
	{
		target = _target;
		actionText.y = target.y + target.height - actionText.height;
		complete = false;
		started = false;
	}
	
	public function begin():Void
	{
		started = true;
		startTweenText();
	}
	
	public function startTweenText(t:FlxTween = null):Void
	{
		if (t == null)
		{
			actionText.alpha = 0;
			add(actionText);			
			var tween:FlxTween = FlxTween.multiVar(actionText, { alpha: 1, y: actionText.y - 20 }, .1, { complete: startTweenText } );
			tween.userData = "wait";
		}
		else
		{
			switch (t.userData)
			{
				case "wait":
					var tween:FlxTween = FlxTween.num(1, 10, .1, { complete: startTweenText } );
					tween.userData = "finish";
					
				case "finish":
					var tween:FlxTween = FlxTween.multiVar(actionText, { alpha: 0, y: actionText.y - 20 }, .1, { complete: startTweenText } );
					tween.userData = "destroy";
					
				case "destroy":
					actionText.exists = false;
					remove(actionText);
					complete = true;
			}
		}
		
	}	
	
}