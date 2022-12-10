package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.*;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import gameObjects.*;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;

using StringTools;
/**
	*DEBUG MODE
 */

class AnimationDebug extends FlxState
{
	var _file:FileReference;
	var bf:Boyfriend;
	var gf:Character;
	var isGf:Bool;
	var dad:Character;
	var shade:Character;

	public static var charFlip:Bool;

	var char:Character;
	var textAnim:FlxText;
	var dumbTexts:FlxTypedGroup<FlxText>;
	var animList:Array<String> = [];
	var curAnim:Int = 0;
	var isDad:Bool = true;
	var daAnim:String = 'spooky';
	var camFollow:FlxObject;
	var flipText:FlxText;

	var characterDrop:FlxUIDropDownMenu;
	var UI_box:FlxUITabMenu;

	public function new(daAnim:String = 'spooky')
	{
		super();
		this.daAnim = daAnim;
	}

	override function create()
	{
		FlxG.sound.music.stop();

		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);

		var stage = new Stage("stage");
		add(stage);

		if (daAnim == 'bf')
			isDad = false;

		if (isDad)
		{
			dad = new Character(false);
			dad.setCharacter(0, 0, daAnim);
			dad.screenCenter();
			dad.debugMode = true;

			shade = new Character(false);
			shade.screenCenter();
			shade.setCharacter(0, 0, daAnim);
			shade.playAnim('idle');

			shade.alpha = 0.8;
			shade.color = 0xFF140C1f;
			shade.debugMode = true;
			add(shade);
			add(dad);

			char = dad;
			dad.flipX = false;
		}
		else if (isGf)
		{
			gf = new Character(false);
			gf.screenCenter();
			gf.setCharacter(0, 0, daAnim);
			gf.debugMode = true;

			shade = new Character(false);
			shade.screenCenter();
			shade.setCharacter(0, 0, daAnim);
			shade.playAnim('idle');

			shade.alpha = 0.8;
			shade.color = 0xFF140C1f;
			shade.debugMode = true;
			add(shade);
			add(gf);

			char = gf;
		}
		else
		{
			bf = new Boyfriend();
			bf.screenCenter();
			bf.setCharacter(0, 0, daAnim);
			bf.debugMode = true;

			shade = new Character(false);
			shade.setCharacter(0, 0, daAnim);
			shade.screenCenter();
			shade.playAnim('idle');

			shade.alpha = 0.8;
			shade.color = 0xFF140C1f;
			shade.debugMode = true;
			add(shade);
			add(bf);

			char = bf;
			bf.flipX = false;
		}
		shade.screenCenter();

		dumbTexts = new FlxTypedGroup<FlxText>();
		add(dumbTexts);
		flipText = new FlxText(20, 30, 0, '', 32);
		add(flipText);

		textAnim = new FlxText(300, 16);
		textAnim.size = 26;
		textAnim.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		textAnim.scrollFactor.set();
		add(textAnim);

		genBoyOffsets();

		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);

		FlxG.camera.follow(camFollow);
		var tabs = [{name: "Assets", label: 'Assets'}, {name: "Character", label: 'Character'}];

		UI_box = new FlxUITabMenu(null, tabs, true);

		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2 + 150;
		UI_box.y = 20;
		add(UI_box);
		addEditorUI();

		super.create();
	}

	var characters:Array<String> = CoolUtil.coolTextFile(Paths.txt('characterList'));

	var shet:String;

	function addEditorUI():Void
	{
		characterDrop = new FlxUIDropDownMenu(10, 100, FlxUIDropDownMenu.makeStrIdLabelArray(characters, true), function(character:String)
		{
			shet = characters[Std.parseInt(character)];
			FlxG.switchState(new AnimationDebug(shet));
			// remove(dad);
			// remove(shade);

			// shade = new Character(0, 0, shet, false);
			// shade.debugMode = true;
			// shade.screenCenter();
			// shade.alpha = 0.8;
			// shade.color = 0xFF140C1f;
			// shade.playAnim("idle");
			// add(shade);

			// dad = new Character(0, 0, shet, false);
			// dad.debugMode = true;
			// dad.screenCenter();
			// add(dad);
			// remove(dumbTexts);
			// add(dumbTexts);
			// remove(textAnim);
			// add(textAnim);
			// genBoyOffsets();
		});
		characterDrop.selectedLabel = shet;

		var tab_group_char = new FlxUI(null, UI_box);
		tab_group_char.name = "Assets";
		// tab_group_char.add(UI_songTitle);

		tab_group_char.add(characterDrop);

		UI_box.addGroup(tab_group_char);
		UI_box.scrollFactor.set();
	}

	function genBoyOffsets(pushList:Bool = true):Void
	{
		var daLoop:Int = 0;

		for (anim => offsets in char.animOffsets)
		{
			var text:FlxText = new FlxText(10, 20 + (18 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.color = FlxColor.BLUE;
			dumbTexts.add(text);

			if (pushList)
				animList.push(anim);

			daLoop++;
		}
	}

	function saveBoyOffsets():Void
	{
		var result = "";
		for (anim => offsets in char.animOffsets)
		{
			var text = anim + " " + offsets.join(" ");
			result += text + "\n";
		}

		if ((result != null) && (result.length > 0))
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(result.trim(), daAnim + "Offsets.txt");
		}
	}

	/**
	 * Called when the save file dialog is completed.
	 */
	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved OFFSET DATA.");
	}

	/**
	 * Called when the save file dialog is cancelled.
	 */
	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	/**
	 * Called if there is an error while saving the offset data.
	 */
	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving Offset data");
	}

	function updateTexts():Void
	{
		dumbTexts.forEach(function(text:FlxText)
		{
			text.kill();
			dumbTexts.remove(text, true);
		});
	}

	override function update(elapsed:Float)
	{
		daAnim = shet;

		textAnim.text = char.animation.curAnim.name;
		shade.flipX = char.flipX;

		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.ESCAPE)
			FlxG.switchState(new PlayState());

		if (FlxG.keys.pressed.E && FlxG.camera.zoom < 3)
		{
			FlxG.camera.zoom += elapsed * FlxG.camera.zoom;
			if (FlxG.camera.zoom > 3)
				FlxG.camera.zoom = 3;
		}
		if (FlxG.keys.pressed.Q && FlxG.camera.zoom > 0.1)
		{
			FlxG.camera.zoom -= elapsed * FlxG.camera.zoom;
			if (FlxG.camera.zoom < 0.1)
				FlxG.camera.zoom = 0.1;
		}

		if (FlxG.keys.justPressed.F)
			char.flipX = !char.flipX;

		FlxG.save.data.flipX = char.flipX;

		if (FlxG.keys.justPressed.O)
			FlxG.save.data.flipX = !FlxG.save.data.flipX;

		flipText.color = (FlxG.save.data.flipX ? FlxColor.LIME : FlxColor.RED);
		flipText.text = (FlxG.save.data.flipX ? 'FLIP' : 'NO FLIP');

		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L)
		{
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else
				camFollow.velocity.y = 0;

			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}
		else
		{
			camFollow.velocity.set();
		}

		if (FlxG.keys.justPressed.W)
		{
			curAnim -= 1;
		}

		if (FlxG.keys.justPressed.S)
		{
			curAnim += 1;
		}

		if (curAnim < 0)
			curAnim = animList.length - 1;

		if (curAnim >= animList.length)
			curAnim = 0;

		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE)
		{
			char.playAnim(animList[curAnim], true);

			updateTexts();
			genBoyOffsets(false);
		}

		var upP = FlxG.keys.anyJustPressed([UP]);
		var rightP = FlxG.keys.anyJustPressed([RIGHT]);
		var downP = FlxG.keys.anyJustPressed([DOWN]);
		var leftP = FlxG.keys.anyJustPressed([LEFT]);

		var holdShift = FlxG.keys.pressed.SHIFT;
		var multiplier = 1;
		if (holdShift)
			multiplier = 10;

		if (upP || rightP || downP || leftP)
		{
			updateTexts();
			if (upP)
				char.animOffsets.get(animList[curAnim])[1] += 1 * multiplier;
			if (downP)
				char.animOffsets.get(animList[curAnim])[1] -= 1 * multiplier;
			if (leftP)
				char.animOffsets.get(animList[curAnim])[0] += 1 * multiplier;
			if (rightP)
				char.animOffsets.get(animList[curAnim])[0] -= 1 * multiplier;

			updateTexts();
			genBoyOffsets(false);
			char.playAnim(animList[curAnim]);
		}

		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.S)
			saveBoyOffsets();

		super.update(elapsed);
	}
}
