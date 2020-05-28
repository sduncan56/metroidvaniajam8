package;

import flixel.tweens.FlxTween;
import flixel.tile.FlxTile;
import flixel.FlxCamera.FlxCameraFollowStyle;
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

enum CameraPosition {
	Bottom;
	Centre;
}

class PlayState extends FlxState
{
	public static var SpritesheetTexture:FlxAtlasFrames;
	public var player:Player;
	public var enemies:FlxGroup;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var cameraMap:FlxTilemap;

	var moveTween:FlxTween;


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

		cameraMap = map.loadTilemap(AssetPaths.collisions__png, "camera");

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
				camera.follow(player, FlxCameraFollowStyle.PLATFORMER, 1);
				changeCameraPos(Bottom, false);
				//camera.targetOffset.set(0, -(FlxG.stage.height/2)+150);

			case "enemy":
				var enemy = new Enemy(entity.x, entity.y, entity.flippedX);
				
				add(enemy);
				enemies.add(enemy);



			default:
		}
	}

	public function changeCameraPos(pos:CameraPosition, ?tween:Bool=true)
	{
		switch (pos) {
			case Bottom:
				if (tween)
				{
					if (moveTween == null || !moveTween.active)
					    moveTween = FlxTween.tween(camera.targetOffset, {x:0, y:-(FlxG.stage.height/2)+player.height*2+30}, 0.7);
		        }
				else
				    camera.targetOffset.set(0, -(FlxG.stage.height/2)+player.height*2+30);
			case Centre:
				if (tween){
					if (moveTween == null || !moveTween.active)
						moveTween = FlxTween.tween(camera.targetOffset, {x:0, y:0}, 0.7);
                }else
					camera.targetOffset.set(0,0);
			
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

		cameraMap.overlapsWithCallback(player, cameraChangePointHit);
		//FlxG.overlap(player, cameraMap, cameraChangePointHit);
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

	public function cameraChangePointHit(obj:FlxObject, player:FlxObject):Bool
	{
		var tile = cast(obj, FlxTile);

		switch (tile.index)
		{
			case 2:
				changeCameraPos(Centre);
			case 3:
				changeCameraPos(Bottom);

		}


		return false;

	}
}
