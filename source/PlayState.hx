package;

import entities.MagicBullet;
import entities.Entity;
import effects.StunnedShader.StunnedEffect;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxObject;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxG;
import flixel.FlxState;

import entities.Player;
import entities.Enemy;

class PlayState extends FlxState
{
	public static var SpritesheetTexture:FlxAtlasFrames;
	public var player:Player;
	public var enemies:FlxGroup;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;


	override public function create():Void
	{
		super.create();

		bgColor = FlxColor.PURPLE;//FlxColor.setRGB(130, 55, 200, 255);

		SpritesheetTexture = FlxAtlasFrames.fromTexturePackerJson(AssetPaths.spritesheet__png, AssetPaths.spritesheet__json);//FlxAtlasFrames.fromTexturePackerJson(AssetPaths.spritesheet__png, AssetPaths.spritesatlas__json);

		map = new FlxOgmo3Loader(AssetPaths.levels__ogmo, AssetPaths.level1__json);

		walls = map.loadTilemap(AssetPaths.collisions__png, "collisions");
		walls.visible = false;
		walls.setTileProperties(2, FlxObject.ANY);
		//walls.follow();
		add(walls);

		walls.follow();

		var base:FlxTilemap = map.loadTilemap(AssetPaths.tiles__png, "base");
		add(base);

		enemies = new FlxGroup();

	    //FlxG.debugger.visible = true;
		//FlxG.debugger.drawDebug = true;
		

		map.loadEntities(placeEntities, "entities");
		
	}

	private function placeEntities(entity:EntityData)
	{
		switch(entity.name)
		{
			case "player":
				player = new Player(entity.x, entity.y, entity.flippedX);
				player.setOffsets();
				add(player);
				camera.follow(player);
			case "enemy":
				var enemy = new Enemy(entity.x, entity.y, entity.flippedX);
				
				add(enemy);
				enemies.add(enemy);



			default:
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!walls.overlaps(player))
		{
			player.falling = true;
		} else {
			player.falling = false;
			player.jumping = false;
		}





		FlxG.collide(player, walls);
		FlxG.collide(enemies, walls);
		FlxG.overlap(player, enemies, playerEnCol);
		FlxG.overlap(player.magicBullets, enemies, magicHitEnemy);
		//FlxG.overlap(player.)


		for (o in enemies)
		{
			var enemy:Enemy = cast(o, Enemy);

			if (enemy.isOnScreen() && isFacing(enemy, player))
			{
				enemy.setTarget(player);
			}

			if (!walls.overlaps(enemy.seeker))
			{
				enemy.edgeDetectedAhead();
			}
		}

	}

	public function magicHitEnemy(magicBullet:MagicBullet, enemy:Enemy)
	{
		enemy.hitByMagic(magicBullet.magicComponent);
		player.magicBullets.remove(magicBullet);
		magicBullet.destroy();
	}

	public function isFacing(ent1:Entity, ent2:FlxObject)
	{
		if (ent1.x > ent2.x && ent1.facing == FlxObject.LEFT)
			return true;
		if (ent1.x < ent2.x && ent1.facing == FlxObject.RIGHT)
			return true;
		return false;
	}
	public function checkLine(x0:Int, y0:Int, x1:Int, y1:Int, rayCanPass:Int->Int->Bool) {

	}

	public function playerEnCol(player:Player, enemy:Enemy)
	{

	}
}
