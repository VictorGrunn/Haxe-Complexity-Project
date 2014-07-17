package titlescreen;
import flixel.FlxSprite;
import flixel.FlxState;
import source.AssetsRegistry;
import flixel.FlxG;

/**
 * ...
 * @author Victor Grunn
 */
class TitleState extends FlxState
{
	private var titleMenu:TitleMenu;
		
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();				
				
		AssetsRegistry.init();			
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff000000;		
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.show();
		#end
		
		titleMenu = new TitleMenu();
		titleMenu.loadButtons([new TitleStartButton(titleMenu), new TitleOptionsButton(titleMenu), new TitleCreditsButton(titleMenu)]);
		add(titleMenu);		
	}
	
}