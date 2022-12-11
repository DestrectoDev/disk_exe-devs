package gameObjects.userInterface;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.*;
import sys.FileSystem;

using StringTools;

class HealthIcon extends FlxSprite
{
	// rewrite using da new icon system as ninjamuffin would say it
	public var sprTracker:FlxSprite;
	public var initialWidth:Float = 0;
	public var initialHeight:Float = 0;

	public var iconColor:FlxColor = 0xFFFF000;

	var curCharacter:String = "bf";

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		curCharacter = char;
		updateIcon(char, isPlayer);
	}

    function updateBarColor(char:String){
		switch (char)
		{
			case "bf":
				iconColor = 0xFF31b0d1;
			default:
				iconColor = FlxColor.RED;
		}
	}

	public function updateIcon(char:String = 'bf', isPlayer:Bool = false)
	{
		var trimmedCharacter:String = char;
		if (trimmedCharacter.contains('-'))
			trimmedCharacter = trimmedCharacter.substring(0, trimmedCharacter.indexOf('-'));

		var iconPath = char;
		if (!FileSystem.exists(Paths.getPath('images/icons/icon-' + iconPath + '.png', IMAGE)))
		{
			if (iconPath != trimmedCharacter)
				iconPath = trimmedCharacter;
			else
				iconPath = 'face';
			trace('$char icon trying $iconPath instead you fuck');
		}

		antialiasing = true;
		var iconGraphic:FlxGraphic = Paths.image('icons/icon-' + iconPath);
		
		loadGraphic(iconGraphic, true, Std.int(iconGraphic.width / 3), iconGraphic.height);

		initialWidth = width;
		initialHeight = height;

		animation.add('icon', [0, 1, 2], 0, false, isPlayer);
		animation.play('icon');
		scrollFactor.set();
	}

	public dynamic function updateAnim(health:Float)
	{
		if (health < 20){
			animation.curAnim.curFrame = 1;
			if (curCharacter == "susnic")PlayState.dadOpponent.iconColor = 0xFF1f2494;
		}
		else if (health > 80){
			animation.curAnim.curFrame = 2;
			if (curCharacter == "susnic")PlayState.dadOpponent.iconColor = 0xFF436dc1;
		}
		else{
			animation.curAnim.curFrame = 0;
			if (curCharacter == "susnic")PlayState.dadOpponent.iconColor = 0xFF374daa;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
