package meta.subState;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.*;
import gameObjects.Boyfriend;
import lime.app.Application;
import meta.MusicBeat.MusicBeatSubState;
import meta.data.Conductor.BPMChangeEvent;
import meta.data.Conductor;
import meta.state.*;
import meta.state.menus.*;


class GameOverSubstate extends MusicBeatSubState
{
	//
	var bf:Boyfriend;
	var camFollow:FlxObject;

	public static var stageSuffix:String = "";

	var stageDir:Stage;
	var gf:Character;
	var dadOpponent:Character;
	var app = Application.current.window;
	
	public function new(x:Float, y:Float)
	{
		var daBoyfriendType = PlayState.boyfriend.curCharacter;
		var daBf:String = '';
		switch (daBoyfriendType)
		{
			case 'bf-og':
				daBf = daBoyfriendType;
			case 'bf-pixel':
				daBf = 'bf-pixel-dead';
				stageSuffix = '-pixel';
			case "bffurry":
				daBf = "bffurry-dead";
			default:
				daBf = 'bf-dead';
		}

		super();

		stageDir = new Stage(PlayState.curStage);
		add(stageDir);

		Conductor.songPosition = 0;

		bf = new Boyfriend();
		bf.setCharacter(x, y + PlayState.boyfriend.height, daBf);

		gf = new Character();
		gf.adjustPos = false;
		gf.setCharacter(300, 100, stageDir.returnGFtype(PlayState.curStage));
		gf.scrollFactor.set(0.95, 0.95);

		if (daBf == "bffurry-dead")
			gf.visible = false;

		dadOpponent = new Character().setCharacter(50, 850, PlayState.SONG.player2);

		add(gf);
		add(dadOpponent);
		add(bf);
		
		if (PlayState.curStage == "green_hill")
			add(stageDir.redShade);


		if (PlayState.curStage == "green_hill")
			add(stageDir.redShade);


		PlayState.boyfriend.destroy();

		stageDir.repositionPlayers(PlayState.curStage, bf, dadOpponent, gf);

		camFollow = new FlxObject(bf.getGraphicMidpoint().x + 20, bf.getGraphicMidpoint().y - 90, 1, 1);
		add(camFollow);

		Conductor.changeBPM(100);

		// FlxG.camera.followLerp = 1;
		// FlxG.camera.focusOn(FlxPoint.get(FlxG.width / 2, FlxG.height / 2));
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;

		bf.playAnim('firstDeath');

	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT)
			endBullshit();

		if (controls.BACK)
		{
			FlxG.sound.music.stop();
			PlayState.deaths = 0;

			if (PlayState.isStoryMode)
			{
				Main.switchState(this, new StoryMenuState());
			}
			else
				Main.switchState(this, new FreeplayState());
		}

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12)
			FlxG.camera.follow(camFollow, LOCKON, 0.01);

		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished)
			FlxG.sound.playMusic(Paths.music('gameOver' + stageSuffix));

		// if (FlxG.sound.music.playing)
		//	Conductor.songPosition = FlxG.sound.music.time;
	}

	override function beatHit()
	{
		super.beatHit();

		if (bf != null)
			bf.playAnim("deathLoop");

		if (curBeat % 2 == 0) {
			dadOpponent.dance();
			gf.dance();
		}

		if (curBeat % 2 == 0)
		app.title = "FNF: The Disks Origin's - [DEAD-BUMP] -";
		if (curBeat % 2 == 1)
		app.title = "FNF: The Disks Origin's - [DEAD] -";


		FlxG.log.add('beat');
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		if (!isEnding)
		{
			isEnding = true;
			bf.playAnim('deathConfirm', true);
			FlxG.sound.music.stop();
			FlxG.sound.play(Paths.music('gameOverEnd' + stageSuffix));
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
				{
					Main.switchState(this, new PlayState());
				});
			});
			//
		}
	}
}
