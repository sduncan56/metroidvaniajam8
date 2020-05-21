package entities;

import effects.StunnedShader.StunnedEffect;
import flixel.util.FlxTimer;
import openfl.geom.Point;
import flixel.FlxObject;
import flixel.FlxSprite;

class Enemy extends Entity
{
    private var goal:Point = new Point();
    private var moveTowardGoal:Bool = false;
    private var stunnedTimer:FlxTimer = new FlxTimer();
    var stunnedEffect:StunnedEffect;



    public var speed(default, default):Float = 80;
    public function new(x:Float,y:Float, flipped:Bool)
    {
        super(x, y, flipped);

        animation.frameName = "enemy/enemy.png";
        resetSizeFromFrame();

        stunnedEffect = new StunnedEffect();


    }

    public function setTarget(obj:FlxObject)
    {
        goal.setTo(obj.x, obj.y);
        moveTowardGoal = true;

        
    }

    public function edgeDetectedAhead()
    {
        moveTowardGoal = false;
    }

    public function hitByMagic(effect:MagicComponent)
    {

        if (shader != stunnedEffect.shader)
            shader = stunnedEffect.shader;

        if (stunnedTimer.active)
            stunnedTimer.reset(effect.stunTime);
        else
            stunnedTimer.start(effect.stunTime, stunFinished);

    }

    public function stunFinished(timer:FlxTimer)
    {
        shader = null;
    }

    override public function update(elapsed:Float)
    {
        velocity.x = 0;

        if (moveTowardGoal && !stunnedTimer.active)
        {
            if (x < goal.x)
                velocity.x = speed;
            else if (x > goal.x)
                velocity.x = -speed;
        }

        if (stunnedEffect != null)
            stunnedEffect.update(elapsed);


        super.update(elapsed);
    }
}