package puzzlebase.combatgame.orders;

/**
 * ...
 * @author Victor Grunn
 */
class RoundTickOrder extends OrderTemplate
{

	public function new() 
	{
		super();			
	}
	
	override public function begin():Void 
	{
		super.begin();
		
		if (Reg.puzzleMain.fightScreen.monster != null)
		{
			Reg.puzzleMain.fightScreen.monster.countdownRound();
		}
		
		if (Reg.puzzleMain.fightScreen.player != null)
		{
			Reg.puzzleMain.fightScreen.player.countDownRound();
		}
		
		Reg.puzzleMain.rules.gameStats.resetRound();
		
		onFinalComplete();
	}
	
}