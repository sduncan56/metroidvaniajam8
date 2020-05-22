package entities;


import AmbientMagicParticle.AmbientParticleEmitter;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import haxe.Timer;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;
import openfl.geom.Point;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxSprite;

class Player extends Entity
{
    var speed(default,null):Float = 100;
    var launchSpeed:Float = 500;
    public var falling(default, default):Bool = false;
    public var jumping(default, default):Bool = false;
    public var wandPoint(default, null):Point;

    public var magicBullets(default,null):FlxGroup = new FlxGroup();


    private var timeToCharge:Float = 2.0;
    public var chargeTimer(default, null):FlxTimer = new FlxTimer();

    private var chargeEmitter1:AmbientParticleEmitter;
    public function new(x:Float, y:Float, flipped:Bool) {
        super(x, y, flipped);

        animation.frameName = "player/player1.png";
        resetSizeFromFrame();

        animation.addByNames("charging_90", ["player/player2.png"], 1, false);

        animation.addByNames("fire_magic", ["player/player1.png"], 1, false);



        offset.x = 4;
        width -= 8;
        //origin.x -= 16;
        //offset.x -= 16;

        wandPoint = new Point(x+width, y+height/2);

        chargeEmitter1 = new AmbientParticleEmitter(wandPoint, 30);
        chargeEmitter1.visible = false;
        FlxG.state.add(chargeEmitter1);

    }

    private function returnToIdle()
    {
        resetSizeFromFrame();
        offset.x = 4;
        width -= 8;

    }

    private function move(elapsed:Float)
    {
		if (!jumping) {
			velocity.x = 0;
		}

		if (!falling && !chargeTimer.active) {
			if (FlxG.keys.anyPressed([UP, W]) && isTouching(FlxObject.FLOOR)) {
				velocity.y = -300;
				jumping = true;
			}
			if (FlxG.keys.anyPressed([DOWN, S])) {}

			if (FlxG.keys.anyPressed([LEFT, A])) {
				velocity.x = -speed;
			}

			if (FlxG.keys.anyPressed([RIGHT, D])) {
				velocity.x = speed;
			}
		} else {
			acceleration.y = 1000;
		}
    
    }

    private function chargeFinished(timer:FlxTimer)
    {
        chargeEmitter1.kill();

    }

    private function shoot()
    {
        //wandPoint.setTo(x+width, y+height/2); //gonna need more math when we do the animations

        if (FlxG.mouse.justPressed)
        {
            animation.play("charging_90");
            resetSizeFromFrame();
            chargeTimer.start(timeToCharge, chargeFinished);

            if (facing == FlxObject.RIGHT)
                chargeEmitter1.setClusterPoint(wandPoint.x+40, wandPoint.y);
            else if (facing == FlxObject.LEFT)
                chargeEmitter1.setClusterPoint(wandPoint.x-40, wandPoint.y);

            
            chargeEmitter1.makeParticles(2,2,FlxColor.LIME, 300);
            chargeEmitter1.launchMode = FlxEmitterMode.CIRCLE;
            chargeEmitter1.start(false,0.01);

            //chargeEmitter1.


        }


        if (FlxG.mouse.justReleased && !chargeTimer.active)
        {
            var bullet = new MagicBullet(wandPoint.x, wandPoint.y, "greenball");
            FlxG.state.add(bullet);
            magicBullets.add(bullet);

            var mouseX = FlxG.mouse.x;
            var mouseY = FlxG.mouse.y;

            var fireAngle = Math.atan2((mouseY-wandPoint.y), (mouseX-wandPoint.x));
            bullet.velocity.x = launchSpeed*Math.cos(fireAngle);
            bullet.velocity.y = launchSpeed*Math.sin(fireAngle);

            animation.play("fire_magic");

            returnToIdle();
        } else if (FlxG.mouse.justReleased)
        {
            animation.play("fire_magic"); //maybe change later
            returnToIdle();

        }
    }

    override public function update(elapsed:Float)
    {

        if (FlxG.mouse.x < x)
        {
            facing = FlxObject.LEFT;
            flipX = true;
            wandPoint.x = x;
        }
        else
        {
            
            facing = FlxObject.RIGHT;
            flipX = false;
            wandPoint.x = x+width;
        }

        move(elapsed);
        shoot();

 


            

        super.update(elapsed);
    }
}