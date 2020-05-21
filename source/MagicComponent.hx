import effects.StunnedShader.StunnedEffect;


class MagicComponent
{
    public var stunTime:Float;
    public var effect:StunnedEffect; //change this.

    public function new(_stunTime:Float) {
        stunTime = _stunTime;
        
    }

}