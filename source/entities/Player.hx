package entities;


import flixel.graphics.FlxGraphic;
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

    private var flipOffset:Int = 13; 
    public function new(x:Float, y:Float, flipped:Bool) {
        super(x, y, flipped);

        animation.frameName = "player/player1.png";

        animation.addByNames("charging_0", ["player/player2.png"], 1, false);
        animation.addByNames("charging_-10", ["player/player2.png"], 1, false);

        animation.addByNames("charging_-20", ["player/player3.png"], 1, false);
        animation.addByNames("charging_-30", ["player/player3.png"], 1, false);

        animation.addByNames("charging_-40", ["player/player4.png"], 1, false);
        animation.addByNames("charging_-50", ["player/player4.png"], 1, false);

        animation.addByNames("charging_-60", ["player/player5.png"], 1, false);
        animation.addByNames("charging_-70", ["player/player5.png"], 1, false);

        animation.addByNames("charging_-80", ["player/player6.png"], 1, false);
        animation.addByNames("charging_-90", ["player/player6.png"], 1, false);


        animation.addByNames("fire_magic", ["player/player1.png"], 1, false);



        //offset.x = tx.offset.x;
        //offset.y = tx.offset.y;


       // offset.x = 4;
        //width -= 8;
        //origin.x -= 16;
        //offset.x -= 16;

        wandPoint = new Point(x+width, y+height/2);

        chargeEmitter1 = new AmbientParticleEmitter(wandPoint, 50);
        chargeEmitter1.visible = false;
        chargeEmitter1.lifespan.set(3, 10);
        chargeEmitter1.width = 60;
        chargeEmitter1.height = 60;
        chargeEmitter1.speed.set(10, 30);
        chargeEmitter1.launchMode = FlxEmitterMode.CIRCLE;
        
        FlxG.state.add(chargeEmitter1);

    }

    public function setOffsets()
    {
        var tx = PlayState.SpritesheetTexture.getByName("player/player1.png");
        width = tx.frame.width;
        y -= tx.offset.y;
    

    }

    private function returnToIdle()
    {
        //resetSizeFromFrame();
        //offset.x = 4;
        //width -= 8;

    }

    private function move(elapsed:Float)
    {
		if (!jumping) {
			velocity.x = 0;
		}

		if (!falling && !chargeTimer.active && !FlxG.mouse.pressed) {
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

    private function getAimAngle(pos1:Point):Float
    {
        var mouseX = FlxG.mouse.x;
        var mouseY = FlxG.mouse.y;

        return Math.atan2((mouseY-wandPoint.y), (mouseX-wandPoint.x));
    }

    private function shoot()
    {
        //wandPoint.setTo(x+width, y+height/2); //gonna need more math when we do the animations


        if (FlxG.mouse.pressed)
        {
            var aimAngle = getAimAngle(wandPoint);
            var degrees = aimAngle*(180/Math.PI);

            var rounded = Math.round(degrees/10)*10;

            if (rounded < -90)
            {
                rounded += (rounded-(-90))*-2;

            }

            animation.play("charging_"+rounded);
            //resetSizeFromFrame();

        }

        if (FlxG.mouse.justPressed)
        {          
            
            chargeTimer.start(timeToCharge, chargeFinished);

            if (facing == FlxObject.RIGHT)
            {
                chargeEmitter1.setClusterPoint(wandPoint.x+40, wandPoint.y);
            }
            else if (facing == FlxObject.LEFT)
            {
                chargeEmitter1.setClusterPoint(wandPoint.x-40, wandPoint.y);
            }

            chargeEmitter1.setPosition(wandPoint.x, wandPoint.y-20);


            //chargeEmitter1.makeParticles(2,2,FlxColor.LIME, 300);
                  
            chargeEmitter1.loadParticles(FlxGraphic.fromFrame(PlayState.SpritesheetTexture.getByName("magic/ambient.png")), 300);
            
            chargeEmitter1.forEachOfType(AmbientMagicParticle, function(particle:AmbientMagicParticle){particle.init(chargeEmitter1.clusterPoint, 60);});
            
            chargeEmitter1.launchMode = FlxEmitterMode.CIRCLE;
            chargeEmitter1.start(false,0.01);

            //chargeEmitter1.


        }


        if (FlxG.mouse.justReleased && !chargeTimer.active)
        {
            var bullet = new MagicBullet(wandPoint.x, wandPoint.y, "greenball");
            FlxG.state.add(bullet);
            magicBullets.add(bullet);

            var fireAngle = getAimAngle(wandPoint);

            bullet.velocity.x = launchSpeed*Math.cos(fireAngle);
            bullet.velocity.y = launchSpeed*Math.sin(fireAngle);

            animation.play("fire_magic");

            returnToIdle();
        } else if (FlxG.mouse.justReleased)
        {
            animation.play("fire_magic"); //maybe change later
            returnToIdle();

            chargeEmitter1.kill();
            chargeTimer.cancel();

        }
    }

    override public function update(elapsed:Float)
    {

        if (FlxG.mouse.x < x)
        {
            if (!flipX)
            {
                offset.x += flipOffset;
                x -= flipOffset;

            }
            facing = FlxObject.LEFT;
            flipX = true;
            wandPoint.x = x;
        }
        else
        {
            if (flipX)
            {
                offset.x -= flipOffset;
                x += flipOffset;
            }
            
            facing = FlxObject.RIGHT;
            flipX = false;
            wandPoint.x = x+width;
        }

        move(elapsed);
        shoot();

 


            

        super.update(elapsed);
    }
}