package playable;

import flixel.*;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.*;
import meta.state.*;
import playable.*;

class Hills extends MusicBeatState
{
	var scoreHUD:FlxSprite;

	public static var daPixelZoom:Float = 6;

	var camHUD:FlxCamera;

	var score:Int = 0;
	var rings:Int = 0;
	var time:Float = 0;

	var lifes:Int = 0;

	var player:Player;
	var collisionShit:FlxSprite;

	var health:Int = 5;
	var infoGame:String = "0";

	// txt
	var infoTxt:FlxText;
	var lifeTxt:FlxText;

	// end
	var bg:FNFSprite;
	var floor:FlxBackdrop;
	var mont:FlxBackdrop;

	override function create()
	{
		super.create();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD);
		FlxG.camera.zoom = 0.7;

		bg = new FNFSprite(0, -40);
		bg.frames = Paths.getSparrowAtlas("hills/stages/Bg");
		bg.animation.addByPrefix("loop", "Bg Idle", 24);
		bg.playAnim("loop");
		bg.scrollFactor.set();
		bg.scale.set(1.4, 1.4);
		bg.alpha = 0.78;
		bg.screenCenter(X);
		add(bg);

		floor = new FlxBackdrop(Paths.image("hills/stages/Floor"), 0, 0, true, true, 0, 0);
		floor.loadGraphic(Paths.image("hills/stages/Floor"), 2035, 1156);
		// backGround.ID = i;
		// floor.velocity.x = Player.SPEED;
		floor.antialiasing = true;
		add(floor);

		mont = new FlxBackdrop(Paths.image("hills/stages/Mountains"), 0, 0, true, true, 0, 0);
		floor.loadGraphic(Paths.image("hills/stages/Mountains"), 2488, 1146);
		// backGround.ID = i;
		// mont.velocity.x = Player.SPEED;
		mont.antialiasing = true;
		add(mont);

		player = new Player(56.05, 415.25);
		player.antialiasing = false;
		player.setGraphicSize(Std.int(player.width * daPixelZoom));
		add(player);

		scoreHUD = new FlxSprite(32, 31.35, Paths.image("UI/base/scoreSpr"));
		scoreHUD.cameras = [camHUD];
		scoreHUD.antialiasing = false;
		scoreHUD.scale.set(0.85, 0.85);
		add(scoreHUD);

		infoTxt = new FlxText(scoreHUD.x - 90, scoreHUD.y + 9, FlxG.width, "pene", 32);
		infoTxt.setFormat(Paths.font("sonic-hud-font"), 62, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		infoTxt.borderSize = 1.43;
		add(infoTxt);

		var collisionShit = new FlxSprite(-44.25, 566.65).makeGraphic(1387, 69, FlxColor.BLACK);
		collisionShit.alpha = 0;
		collisionShit.immovable = true;
		collisionShit.updateHitbox();
		add(collisionShit);
		FlxG.camera.follow(player, LOCKON, 1);

		// add(new FlxText(0, 0, 0, "Hello World!", 32).screenCenter());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// FlxG.overlap(player, ringSpr, ringSpr.collect);

		FlxG.collide(player, collisionShit);

		// infoGame = ' : $score' + '\n : $time' + '\n : $rings';
		infoTxt.text = ' : $score' + '\n\n : $time' + '\n\n : $rings';
		// infoTxt.x = scoreHUD.x + 17 + infoTxt.width;

		if (FlxG.keys.pressed.E)
			score++;

		if (FlxG.keys.justPressed.Q)
			rings++;

		time += Math.floor(elapsed * 60);

		if (controls.BACK)
			Main.switchState(this, new meta.state.menus.SelectState());

		if (FlxG.keys.justPressed.R)
			FlxG.resetState();
	}
}