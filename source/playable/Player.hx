package playable;

import flixel.*;
import flixel.util.*;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	var holdTimer:Float;

	public var SPEED:Int = 400;

	public var GRAVITY:Int = 900;

	public static var eventvalue:Bool = true;

	public var debugMode:Bool = false;

	public var animOffsets:Map<String, Array<Dynamic>>;

	public function new(X, Y)
	{
		super(X, Y);
		animOffsets = new Map<String, Array<Dynamic>>();

		drag.x = SPEED * 4;
		drag.y = SPEED * 4;

		makeGraphic(5, 5, FlxColor.RED);

		// loadOffsetFile("tails");

		if (!debugMode)
		{
			acceleration.y = GRAVITY;
		}
		else
		{
			acceleration.y = 0;
		}

		updateHitbox();
	}

	var walkMode:Bool = true;

	// public function loadOffsetFile(char:String = "tails")
	// {
	// 	var offset:Array<String> = CoolTools.coolTextFile('assets/data/offsets/${char}Offsets.txt');

	// 	for (i in 0...offset.length)
	// 	{
	// 		var data:Array<String> = offset[i].split(' ');
	// 		addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
	// 	}
	// }

	public function moveTails(move:Bool = true, elapsed:Float)
	{
		var right = FlxG.keys.anyPressed([RIGHT, D]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN]);
		// var shifty = FlxG.keys.pressed.SHIFT;
		// var down = FlxG.keys.anyPressed([DOWN, S]);
		// var down = FlxG.keys.anyPressed([DOWN, S]);
		// var down = FlxG.keys.anyPressed([DOWN, S]);

		if (move && !debugMode)
		{
			if (left || right && walkMode)
			{
				playAnim("walk");
			}
			else
				playAnim("idle");
			{
				setFacingFlip(FlxObject.LEFT, true, false);
				setFacingFlip(FlxObject.RIGHT, false, false);
			}
			if (down && right)
			{
				SPEED = 700;
				playAnim("spindash");
			}
			if (down && left)
			{
				SPEED = 700;
				playAnim("spindash");
			}
			if (right)
			{
				velocity.x = SPEED;
				facing = FlxObject.RIGHT;
			}
			else if (left)
			{
				velocity.x = -SPEED;
				facing = FlxObject.LEFT;
			}
			else if (up)
			{
				playAnim("lookinup");
			}
			else if (down)
			{
				playAnim("crouched");
			}
			if (left || right)
			{
				new FlxTimer().start(2.5, function(tmr)
				{
					SPEED += Std.int(elapsed * 500);
				});
			}
		}
	}

	public function jumpTails(canJump:Bool = true)
	{
		if (canJump)
		{
			var jump = FlxG.keys.anyPressed([SPACE, SHIFT, S]);
			if (jump && isTouching(FlxObject.FLOOR))
			{
				animation.play('spindash');

				angle += FlxG.elapsed;

				velocity.y = -GRAVITY / 1.5;
			}
			if (FlxG.keys.anyJustReleased([SPACE, SHIFT, S]))
			{
				angle = 0;
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0)
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		moveTails(eventvalue, elapsed);
		jumpTails(true);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
