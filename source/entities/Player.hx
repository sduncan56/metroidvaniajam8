package entities;


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
    public function new(x:Float, y:Float, flipped:Bool) {
        super(x, y, flipped);

        animation.frameName = "player/player1.png";
        resetSizeFromFrame();


        width -= 16;
        //origin.x -= 16;
        //offset.x -= 16;

        wandPoint = new Point(x+width, y+height/2);

    }

    private function move(elapsed:Float)
    {
		if (!jumping) {
			velocity.x = 0;
		}

		if (!falling) {
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

    private function shoot()
    {
        wandPoint.setTo(x+width, y+height/2); //gonna need more math when we do the animations

        if (FlxG.mouse.justReleased)
        {
            var bullet = new MagicBullet(wandPoint.x, wandPoint.y, "greenball");
            FlxG.state.add(bullet);
            magicBullets.add(bullet);

            var mouseX = FlxG.mouse.x;
            var mouseY = FlxG.mouse.y;

            var fireAngle = Math.atan2((mouseY-wandPoint.y), (mouseX-wandPoint.x));
            bullet.velocity.x = launchSpeed*Math.cos(fireAngle);
            bullet.velocity.y = launchSpeed*Math.sin(fireAngle);
        }
    }

    override public function update(elapsed:Float)
    {

        if (FlxG.mouse.x < x)
        {

            flipX = true;
        }
        else
        {
            flipX = false;
        }

        move(elapsed);
        shoot();

 


            

        super.update(elapsed);
    }
}