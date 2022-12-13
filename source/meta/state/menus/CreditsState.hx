package meta.state.menus;

import flixel.*;
import meta.MusicBeat.MusicBeatState;
import meta.state.menus.*;

class CreditsState extends MusicBeatState
{
    override function create()
        {
            super.create();
        }

    override function update(ELAPSED:Float)
        {
            super.update(ELAPSED);

            if (controls.BACK)
                Main.switchState(this, new SelectState());
        }
}