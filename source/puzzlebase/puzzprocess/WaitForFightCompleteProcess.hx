package puzzlebase.puzzprocess;
import flash.events.Event;
import flash.Lib;

/**
 * ...
 * @author Victor Grunn
 */
class WaitForFightCompleteProcess extends ProcessPart
{

	public function new() 
	{
		super();
	}
	
	override public function begin():Void
	{
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e:Event):Void
	{
		if (Reg.puzzleMain.fightScreen.processing == false)
		{
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			onFinalComplete();
		}
	}
	
	override public function flush():Void 
	{
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		super.flush();		
	}
	
}