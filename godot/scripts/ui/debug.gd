extends Control

func _process(delta):
	$BottomLeft/FPS.text = "FPS: %s" % int(1/delta);
	if Micro.player:
		$BottomLeft/Pos.text = "Position: %s" % round(Micro.player.global_position)
		$BottomLeft/Tile.text = "Tile: %s" % round(Micro.player.global_position / 20.)
		var spores = Micro.player.get_node("Camera/GlobalParticles/Spores")
		$BottomRight/Spores.text = "Spores %s @ %s" % ["ON" if spores.emitting else "OFF", spores.amount_ratio]

func _first_shown() -> void:
	if Micro.world:
		$TopLeft/Seed.text = "World seed: %s" % Micro.world.world_seed
