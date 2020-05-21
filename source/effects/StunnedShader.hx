package effects;

import flixel.system.FlxAssets.FlxShader;

class StunnedEffect
{
    public var shader(default, null):StunnedShader = new StunnedShader();

    public function new()
    {
        shader.uTime.value = [0];
    }

    public function update(elapsed:Float)
    {
        shader.uTime.value[0] += elapsed;
    }
}

class StunnedShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        uniform float uTime;
        
        void main()
        {
            vec2 pt = openfl_TextureCoordv;

            vec4 base = texture2D(bitmap, openfl_TextureCoordv);

            float y = 0.0;

            if (base.a > 0.5)
            {
                y = sin(pt.y * 3.0 + uTime);
                //base.r *= sin(uTime);
                //base.g *= cos(uTime);
                base.r = y;

                

            }
            gl_FragColor = base;
            
            
            //vec2 uv = vec2(pt.x,pt.y+y);
            

            //gl_FragColor = texture2D(bitmap, uv);
        }
    ')

    public function new()
    { 
        super();
    }
}