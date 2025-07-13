extends Control

func _process(delta):
	$BottomRight/FPS.text = "FPS: %s" % int(1/delta);
	if Micro.player:
		$BottomLeft/Pos.text = "Position: %s" % round(Micro.player.global_position)
		$BottomLeft/Tile.text = "Tile: %s" % round(Micro.player.global_position / 20.)
		$BottomLeft/Biome.text = "Biome: %s" % Micro.world.Biome.find_key(Micro.world.get_biome(Micro.world.tile_at(Micro.player.global_position)))
		$TopRight/WorldEnemies.text = "%s / %s world enemies" % [Micro.world.world_enemies, Micro.world.spawn_cap()]
		
func _first_shown() -> void:
	if Micro.world:
		$TopLeft/Seed.text = "World seed: %s" % Micro.world.world_seed
