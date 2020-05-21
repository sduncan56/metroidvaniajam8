package entities;

import flixel.FlxSprite;

class MagicBullet extends FlxSprite
{
    public var magicComponent(default, null):MagicComponent;
    public function new(x:Float, y:Float, type:String)
    {
        super(x,y);

        frames = PlayState.SpritesheetTexture;
        animation.frameName = "magic/"+type+".png";
        resetSizeFromFrame();

        magicComponent = new MagicComponent(3);


    }
}