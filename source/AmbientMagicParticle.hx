import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.tweens.FlxTween;
import openfl.geom.Point;
import flixel.effects.particles.FlxParticle;


class AmbientParticleEmitter extends FlxTypedEmitter<AmbientMagicParticle>
{
    private var clusterPoint:Point;
    private var range:Float;
    private var randomNumberGen:FlxRandom;
    public function new(_clusterPoint:Point, _range:Float)
    {
        super();
        clusterPoint = _clusterPoint;
        range = _range;

        randomNumberGen = new FlxRandom();
    }

    override public function makeParticles(Width:Int = 2, Height:Int = 2, Color:FlxColor = FlxColor.WHITE, Quantity:Int = 50):FlxTypedEmitter<AmbientMagicParticle>
    {
		for (i in 0...Quantity) {
			var particle:AmbientMagicParticle = new AmbientMagicParticle(clusterPoint, range);//T = Type.createInstance(particleClass, []);
			particle.makeGraphic(Width, Height, Color);
			add(particle);
		}

        return this;

    }

    public function setClusterPoint(_x:Float, _y:Float)
    {
        clusterPoint.setTo(_x, _y);
    }

    override public function update(elapsed:Float)
    {
        var r2 = 180*Math.PI/180;

        var a:Float = randomNumberGen.float(0, 6.2);
        x = clusterPoint.x + range+50 * Math.cos(a);
        y = clusterPoint.y + range+50 * Math.sin(a);

        super.update(elapsed);
    }

}

class AmbientMagicParticle extends FlxParticle
{
    private var clusterPoint:Point;
    private var range:Float;

    public function new(_clusterPoint:Point, _range:Float) {
        super();

        clusterPoint = _clusterPoint;
        range = _range;
        
    }

    override public function update(elapsed:Float)
    {
        if (Math.abs(clusterPoint.x-x) < range &&
            Math.abs(clusterPoint.y-y) < range)
        {
            FlxTween.tween(this, {x:clusterPoint.x, y: clusterPoint.y},1,{onComplete: reachedPoint});
        }
        else{
            super.update(elapsed);
        }

    }

    public function reachedPoint(tween:FlxTween)
    {
        kill();

    }


}