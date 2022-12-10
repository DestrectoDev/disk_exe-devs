package meta.state.menus;

import flixel.*;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.util.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.FNFTransition;
import meta.data.dependency.FNFUIState;
import meta.state.*;

class LoadingState extends MusicBeatState{
    var loadingSpr:FlxSprite;

    var randomTxt:FlxText;

    var ringSpr:FlxSprite;

    public function new (switched:Bool = true) {

      super();
     
      loadingSpr = new FlxSprite(-85);
      loadingSpr.loadGraphic(Paths.image("loadingscreen/" + FlxG.random.int(0, 2) + "screen"));
      loadingSpr.antialiasing = true;
      add(loadingSpr);

      randomTxt = new FlxText(70, 280, FlxG.width, "Hola soy assman y este s edisk oriingisd", 42);
      randomTxt.setFormat(Paths.font('vcr.ttf'), 26, FlxColor.WHITE);
      randomTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
      add(randomTxt);

		// w:224.85;
        // h: 220;
      ringSpr = new FlxSprite(670, 850);
      ringSpr.loadGraphic(Paths.image("UI/default/rings"), true, 224, 220);
      ringSpr.animation.add("loop", [0, 1, 2, 3], 24);
      ringSpr.animation.play("loop");
      ringSpr.antialiasing = false;
      ringSpr.setGraphicSize(Std.int(ringSpr.width * 6));
      add(ringSpr);
    }

    public static function loadAndSwitchState(state:FlxState, target:FlxState){
		new FlxTimer().start(2.5, function(tmr:FlxTimer)
		{
        if (!FlxTransitionableState.skipNextTransIn)
        {
            state.openSubState(new FNFTransition(0.35, false));
            FNFTransition.finishCallback = function()
            {
                FlxG.switchState(target);
            };
				return trace('changed state');
			}
			FlxG.switchState(target);
		});
    }
    
    override public function update(elapsed) {
      super.update(elapsed);

      if (FlxG.keys.justPressed.R)
        FlxG.resetState();
    }
}