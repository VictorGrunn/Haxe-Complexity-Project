package hud;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;
/**
 * ...
 * @author ...
 */
class HealthBar extends FlxGroup
{
	private var healthBG:FlxSprite;
	private var healthBar:FlxSprite;
	
	public function new() 		
	{
		super();
		
		healthBG = new FlxSprite();
		healthBG.makeGraphic(Std.int(FlxG.width / 8), 6);			
		
		var stamper:FlxSprite = new FlxSprite();
		stamper.makeGraphic(Std.int(healthBG.width) - 4, 4, 0xffff0000);
		healthBG.stamp(stamper, 2, 1);
		
		stamper.destroy();
		
		healthBar = new FlxSprite();
		healthBar.makeGraphic(Std.int(healthBG.width) -4, 4, 0xff00ff00);
		healthBar.origin.x = 0;
		
		FlxSpriteUtil.screenCenter(healthBG, true, false);		
		
		add(healthBG);
		add(healthBar);	
		
		healthBG.visible = false;
		healthBar.visible = false;
	}
	
	public function changeHealth(_currentHP:Float, _maxHP:Float, _target:FlxSprite):Void
	{
		exists = true;
		
		healthBG.x = _target.x + _target.width / 2 - healthBar.width / 2;
		healthBG.y = _target.y + _target.height + 2;
		healthBar.x = healthBG.x + 2;
		healthBar.y = healthBG.y + 1;		
		
		healthBar.visible = true;
		healthBG.visible = true;
		
		if (_currentHP <= 0)
		{
			healthBar.visible = false;
			healthBG.visible = false;
			
			_currentHP = 0;			
		}
		
		healthBar.scale.x = _currentHP / _maxHP;		
	}
	
	public function giveLocationPoint():FlxPoint
	{
		var fpoint:FlxPoint = new FlxPoint(healthBG.x, healthBG.y);
		return fpoint;
	}
	
	public function changeLocation(_x:Float, _y:Float):Void
	{
		FlxSpriteUtil.screenCenter(healthBG, true, false);
		
		healthBG.y = _y;
		
		healthBar.x = healthBG.x + 2;
		healthBar.y = healthBG.y + 2;		
	}
	
}