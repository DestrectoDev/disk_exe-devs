package meta.state.menus;


import flixel.*;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;


class CreditsState extends MusicBeatState
{
    var someShit:Array<SHIT> = [];
    var curCred:Int = 0;
    var textCred:FlxText;
    var credshit:Array<String> = ['directors', 'programers'];
    var credGrp:FlxTypedGroup<FlxSprite>;
    var camFollow:FlxObject;
    var backGround:FlxBackdrop;
    var arrowRight:FlxSprite; var arrowLeft:FlxSprite;
    var intendedColor:Int;
    var colorTween:FlxTween;
    var colors:Array<Dynamic> = [
        '0xFFFD71D3',
        '0xFF8F0099'
    ];
    /**
        for Later Shit
    **/
    var creditData:Array<Dynamic> = [
      [
        "treno", // name of crew
        "0xFFFD71D3", //color
        "directors", // funciion en el mod
        "hola pro, me llamo treno y soy pro bro" //info
      ],
      [
        "assman",
        "0x08EBB2",
        "programmer",
        "hola soy assman, primero chupadme la polla tio"
      ]
    ];
    override function create()
        {
            super.create();

            for (i in 0...colors.length)
                {
            someShit.push(new SHIT(FlxColor.fromString(colors[i])));
                }

    backGround = new FlxBackdrop(Paths.image("menus/base/back_menu_white"), 0, 0, true, true, 0, 0);
		backGround.velocity.x = -310;
		backGround.screenCenter(Y);
		backGround.antialiasing = true;
		add(backGround);

        textCred = new FlxText(20, 20, '', 74);
        textCred.setFormat(Paths.font('Sonic Advanced 2.ttf'), 74);
        textCred.updateHitbox();
        textCred.scrollFactor.set();
        add(textCred);

        camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

        credGrp = new FlxTypedGroup<FlxSprite>();
        add(credGrp);

        for (i in 0...credshit.length)
            {
                var sprite = new FlxSprite(6000 + (i * 2000), 0);
                sprite.ID = i;
                sprite.scale.set(0.3, 0.3);
                sprite.updateHitbox();
                sprite.loadGraphic(Paths.image('menus/base/creds/' + credshit[i]));
                sprite.screenCenter(Y);
                credGrp.add(sprite);
            }

            arrowRight = new FlxSprite(1140, 200);
            arrowRight.loadGraphic(Paths.image('menus/base/arrow_indicator'));
            arrowRight.scrollFactor.set();
            arrowRight.antialiasing = true;
            arrowRight.scale.set(0.7, 0.7);
            add(arrowRight);

            arrowLeft = new FlxSprite(20, 200);
            arrowLeft.loadGraphic(Paths.image('menus/base/arrow_indicator'));
            arrowLeft.scrollFactor.set();
            arrowLeft.flipX = true;
            arrowLeft.antialiasing = true;
            arrowLeft.scale.set(0.7, 0.7);
            add(arrowLeft);

            FlxG.camera.follow(camFollow, null, 0.04);

            selection();
       
            var shade = new FlxSprite(0, 0, Paths.image("menus/base/shade"));
            shade.screenCenter();
            shade.alpha = 0.8;
            add(shade);
        }

    override function update(ELAPSED:Float)
        {
            super.update(ELAPSED);

            if (controls.LEFT_P)
                selection(-1);
            if (controls.RIGHT_P)
                selection(1);

            if (controls.BACK)
                Main.switchState(this, new SelectState());
        }

        function selection(bruh:Int = 0)
            {
                FlxG.sound.play(Paths.sound('sonidito_de_selector'));

                curCred += bruh;

                if (curCred >= credshit.length)
                    curCred = credshit.length - 1;
                if (curCred < 0)
                    curCred = 0;

                if (curCred == credshit.length - 1)
                    arrowRight.visible = false;
                else
                    arrowRight.visible = true;

                if (curCred == 0)
                    arrowLeft.visible = false;
                else
                    arrowLeft.visible = true;

                textCred.text = credshit[curCred];

                switch (curCred)
		{
		 default:
            var newColor:Int = someShit[curCred].menuColor;
            if (newColor != intendedColor)
				{
					if (colorTween != null)
					{
						colorTween.cancel();
					}
					intendedColor = newColor;
			colorTween = FlxTween.color(backGround, 1, backGround.color, someShit[curCred].menuColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
        }
		}

                credGrp.forEach(function(spr:FlxSprite)
                    {
if (spr.ID == curCred)
    {
        camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);

    }
                    });
            }
}

class SHIT
{
	public var menuColor:Int = 0xFFffffff;

	public function new(menuColor:Int = 0xFFffffff)
	{
		this.menuColor = menuColor;
	}
}