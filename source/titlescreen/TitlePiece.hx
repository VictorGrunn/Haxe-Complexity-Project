package titlescreen;
import flash.events.Event;
import flash.Lib;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import source.AssetsRegistry;

/**
 * ...
 * @author Victor Grunn
 */
class TitlePiece extends FlxGroup
{
	public var complete:Bool = false;
	public var name:String;
	
	private var titleMenu:TitleMenu;	
	
	public var optionText:FlxText;

	public function new(_titleMenu:TitleMenu) 
	{
		titleMenu = _titleMenu;
		
		super();				
	}	
	
	public function init(_name:String):Void
	{
		name = _name;	
				
		optionText = new FlxText(0, 0, 400);
		
		optionText.visible = true;
		
		optionText.setFormat(null, 20, 0xffffff, "center");
		optionText.text = name;
		optionText.draw();
		add(optionText);		
	}
	
	public function begin():Void
	{
		
	}
	
	public function onFinalComplete(t:FlxTween = null):Void
	{		
		titleMenu.endButton();
		complete = true;
	}
	
	private function onEnterFrame(e:Event):Void
	{
		
	}
	
	override public function update():Void 
	{
		super.update();		
		
		if (FlxG.mouse.justPressed && optionText != null && GrunnUtil.overlapCheck(optionText))
		{
			titleMenu.processButton(this);					
		}
	}
	
	override public function destroy():Void 
	{		
		if (optionText != null)
		{
			optionText.exists = false;
			remove(optionText);
		}
		
		titleMenu = null;
		
		name = "";		
		
		super.destroy();
	}
	
}