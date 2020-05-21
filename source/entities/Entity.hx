package entities;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;

class Entity extends FlxSprite
{
    public var seeker(default, null):FlxObject;
    public function new(x:Float,y:Float, flipped:Bool)
    {
        super(x,y);
    
        frames = PlayState.SpritesheetTexture;

        seeker = new FlxObject(x+width, y+height, 10, 10);
        FlxG.state.add(seeker);

        if (!flipped)
            facing = FlxObject.RIGHT;
        else {
            facing = FlxObject.LEFT;
            flipX = true;
            seeker.x = x-seeker.width;
        }
    }

    override public function update(elapsed:Float) {
        seeker.y = y+height;
        if (facing == FlxObject.RIGHT)
        {
            seeker.x = x+width;
        }
        else if (facing == FlxObject.LEFT)
        {
            seeker.x = x-seeker.width;
        }

        super.update(elapsed);
        
    }
}