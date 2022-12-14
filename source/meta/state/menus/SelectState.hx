package meta.state.menus;

// from the sonic exe similar selection shit

import flixel.*;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.*;
import flixel.text.*;
import flixel.util.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.*;
import playable.*;

using StringTools;

class SelectState extends MusicBeatState{

    var backGround:FlxSprite;

	var boxThing:FNFSprite;

    var boxGrp:FlxTypedGroup<FNFSprite>;
    var lockGrp:FlxTypedGroup<FNFSprite>;

	public static  var curSelected:Int = 0;

    public static var storySongs:Array<Dynamic> = [
		["Melancholyc-tentation", "Melancholyc-tentatio", "Demonic-run"],
        ["place 1", "place 2", "place 3"],
        ["place 1", "place 2", "place 3"],
        ["place 1", "place 2", "place 3"]
    ];

    var box:FNFSprite;
    var ach:FNFSprite;
    var sett:FNFSprite;
    var vic:FNFSprite;
    var data:FNFSprite;

	public static var blockedWeek:Array<Bool> = [true, false, false, false];
    
    override public function create(){

		ForeverTools.resetNewMenuMusic(true);

		boxGrp = new FlxTypedGroup<FNFSprite>();
		lockGrp = new FlxTypedGroup<FNFSprite>();
        

        // for (i in 0...3){
        //     // backGround = new FlxSprite(0, 0, Paths.image("menus/base/back_menu"));
        //     // backGround.ID = i;
        //     // backGround.x = backGround.width + (i * backGround.width);
        //     // backGround.screenCenter(Y);
        //     // backGround.antialiasing = true;
        //     // add(backGround);

		var backGround = new FlxBackdrop(Paths.image("menus/base/back_menu"), 0, 0, true, true, 0, 0);
		// backGround.ID = i;
		backGround.velocity.x = -190;
		backGround.screenCenter(Y);
		backGround.antialiasing = true;

		add(backGround);
        // }

		for (i in 0...Main.gameWeeks.length){
           boxThing = new FNFSprite(0, -19);
           boxThing.frames = Paths.getSparrowAtlas("menus/base/seleccion");
           boxThing.animation.addByPrefix("idle", "idle", 24);
           boxThing.animation.addByPrefix("select", "seleccion", 24);
           boxThing.playAnim("idle");
           boxThing.addOffset("select", 12, 0);

           boxThing.x = -98 +  (i * 310);
        //    boxThing.y -= 72;
           boxThing.antialiasing = true;
           boxThing.updateHitbox();
           boxThing.setGraphicSize(Std.int(boxThing.width * 0.79));
           boxThing.ID = i;

           if (!blockedWeek[i]){
            var consistentPosition:Array<Float> = [(boxThing.x + (boxThing.width / 2)) - 93, (boxThing.y + (boxThing.height / 3))];
             var padlock = new FNFSprite(consistentPosition[0], consistentPosition[1]);
             padlock.frames = Paths.getSparrowAtlas("menus/base/padLock");
             padlock.animation.addByPrefix("idle", "idle", 24);
             padlock.animation.addByPrefix("open", "romper", 24, false);
             padlock.playAnim("idle");
             padlock.setGraphicSize(Std.int(padlock.width * 0.5));

             boxThing.alpha = 0.7;

             if (blockedWeek[i]){
                padlock.playAnim("open");
                padlock.animation.finishCallback = function(ddh) padlock.destroy();
             }
             
			 lockGrp.add(padlock);
           }
           
           boxGrp.add(boxThing);
        }
	
        add(boxGrp);
		add(lockGrp);

        ach = new FNFSprite (30, 619);
        ach.loadGraphic(Paths.image("menus/base/achievements"));
        ach.antialiasing = true;
        ach.updateHitbox();
        add(ach);

		sett = new FNFSprite(960, 619);
		sett.loadGraphic(Paths.image("menus/base/setings"));
		sett.antialiasing = true;
		sett.updateHitbox();
		add(sett);

		vic = new FNFSprite(544, 613);
		vic.loadGraphic(Paths.image("menus/base/victims"));
		vic.antialiasing = true;
		vic.updateHitbox();
		// vic.screenCenter(X);
		add(vic);

		data = new FNFSprite(409, 509);
		data.loadGraphic(Paths.image("menus/base/data select"));
		data.antialiasing = true;
		data.updateHitbox();
		add(data);

		box = new FNFSprite(ach.x - (ach.width / 2) + 55, 596.3);
        box.loadGraphic(Paths.image("menus/base/box"));
        box.antialiasing = true;
		box.x = ach.x * ((curAlt + 1) * 0.55);

		if (curChangeMode)
			changeFunction();
		else
			changeAlt();
        
        add(box);
    }

    var i = 4;
    
    override public function update(elapsed:Float){
     super.update(elapsed);

    // lockGrp.members[i].setPosition(boxThing.x, boxThing.y - (lockGrp.members[i].height / 2));
    if (FlxG.keys.justPressed.R){
        if (FlxG.keys.pressed.CONTROL)
            FlxG.resetGame();
        
        FlxG.resetState();
    }

   

	 box.visible = !curChangeMode;

	if (!curChangeMode) {
	   boxGrp.members[curSelected].playAnim("idle");
    }
	else {
	   boxGrp.members[curSelected].playAnim("select");
    }


  if (canSelect)  {
    if (controls.UP_P)
        changeMode(true);
    if (controls.DOWN_P)
        changeMode(false);

     if (controls.LEFT_P) {
    if (curChangeMode)
        changeFunction(-1);
    else
        changeAlt(-1);
     }

    if (controls.RIGHT_P) {
    if (curChangeMode)
        changeFunction(1);
    else
        changeAlt(1);
    }
}
   
if (!stopSpam){
     if (controls.ACCEPT){
        if (curChangeMode)
        selectWeek();
        else
		selectData();
     }
   }

    if (FlxG.keys.justPressed.FIVE)
        Main.switchState(this, new Hills());

     if (controls.BACK)
        Main.switchState(this, new TitleState());
     
    }

    var curChangeMode:Bool = true;
	var canSelect:Bool = true;

    public function changeMode(mode:Bool = true){
		FlxG.sound.play(Paths.sound('sonidito_de_selector'));

		curChangeMode = mode;

       trace(Std.string(curChangeMode) + " shit!");
    }

    var curAlt:Int = 0;

    public function changeAlt(huh:Int = 0) {
        curAlt += huh; 
		FlxG.sound.play(Paths.sound('sonidito_de_selector'));

		if (curAlt > 2)
			curAlt = 0;
		if (curAlt < 0)
			curAlt = 2;

       if (curAlt == 2) 
		box.x = ach.x * ((curAlt + 1) * 9.75);
       else if (curAlt == 1)
		box.x = ach.x * ((curAlt + 1) * 7.45);
       else if (curAlt == 0)
		box.x = ach.x * ((curAlt + 1) * 0.51);
    }

	public function changeFunction(sus:Int = 0)
	{
		FlxG.sound.play(Paths.sound('sonidito_de_selector'));

		curSelected += sus;

		if (curSelected >= Main.gameWeeks.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = Std.int(Main.gameWeeks.length - 1);

		boxGrp.forEach(function(item:FNFSprite)
		{
			item.playAnim("idle");
			//    item.text -= Std.(" <");
			if (item.ID == curSelected)
			{
               item.playAnim("select");
			}
		});
	} 
    
    public function selectData() {
        trace (curAlt + " selected!!");
        switch (curAlt){
            case 0:
                Main.switchState(this, new FreeplayState());
            case 1:
				Main.switchState(this, new TitleState());
            case 2:
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;
				Main.switchState(this, new OptionsMenuState());
        }
        
    }

    var stopSpam:Bool = false;
	
    function selectWeek()
	{
		if (blockedWeek[curSelected])
		{
			canSelect = false;
			stopSpam = true;
			PlayState.isStoryMode = true;
			
            FlxG.sound.music.fadeIn(0.8, 1, 0);

			var diffic:String = '-' + CoolUtil.difficultyFromNumber(2).toLowerCase();
			diffic = diffic.replace('-normal', '');

			PlayState.storyPlaylist = Main.gameWeeks[curSelected][0].copy();

			PlayState.storyDifficulty = 2;

			PlayState.SONG = Song.loadFromJson(StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase() + diffic, StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase());
			PlayState.storyWeek = curSelected;
			PlayState.campaignScore = 0;
            
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				FlxG.sound.play(Paths.sound('Risa_Sonic.exe_Efecto_de_sonido'));
			});
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				add(new FlxSprite(0, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK));
			});
			new FlxTimer().start(2.5, function(tmr:FlxTimer)
			{
				Main.switchState(this, new PlayState());
			});
		}
        else{
            canSelect = true;
			stopSpam = false;
            FlxG.camera.shake(0.004, 0.4);
            FlxG.camera.flash(FlxColor.RED, 0.4);
			FlxG.sound.play(Paths.sound('cancelMenu'));
        }
	}
}