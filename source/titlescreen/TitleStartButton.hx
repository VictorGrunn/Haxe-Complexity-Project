package titlescreen;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class TitleStartButton extends TitlePiece
{
	private var sprite:FlxSprite;

	public function new(_title:TitleMenu) 
	{
		super(_title);
		
		init("Start");
	}
	
	override public function begin():Void 
	{
		super.begin();			
		
		var tween:FlxTween = FlxTween.multiVar(titleMenu, { alphaAll: 0 }, .5, { complete: onFinalComplete } );
	}
	
	override public function onFinalComplete(t:FlxTween = null):Void 
	{				
		super.onFinalComplete(t);
		
		FlxG.switchState(new MenuState());
	}
	
}