extends Node2D

class_name World

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var world_seed: int = randi()

var bosses_active: int = 0
var second_trader_miniboss := false

enum Biome {
	LANDING,
	DEFAULT,
	PEACE,
	EMPTINESS
}

var current_biome: Biome = Biome.LANDING
var biome_map: Image
var biomes: Dictionary[Vector2i, Biome] = {}

var world_enemies: int = 0

func world_enemy(biome: Biome, distance: int) -> Enemy:
	var enemies: RollWeights = RollWeights.new()
	match biome:
		Biome.LANDING:
			enemies.add_item(preload("res://entities/enemies/TutorialEnemy.tscn"), 1)
		Biome.DEFAULT:
			enemies.add_item(preload("res://entities/enemies/SpreadShooter.tscn"), 4)
			enemies.add_item(preload("res://entities/enemies/Turret.tscn"), 4)
			if distance >= 100:
				enemies.add_item(preload("res://entities/enemies/MultiShooter.tscn"), 2)
				enemies.add_item(preload("res://entities/enemies/Teleporter.tscn"), 1)
				enemies.add_item(preload("res://entities/enemies/Bomber.tscn"), 1)
			if distance >= 120:
				enemies.add_item(preload("res://entities/enemies/Surpriser.tscn"), 1)
	return Micro.roll(enemies).instantiate()

func spawn_cap() -> int:
	var distance := int(taxicab(tile_at(Micro.player.position)))
	return 1 + ceil(float(distance)/64.)

func spawn_attempt() -> void:
	if bosses_active > 0 or current_biome == Biome.PEACE or world_enemies >= spawn_cap(): return
	var player_pos: Vector2 = tile_at(Micro.player.position)
	var distance: int = int(taxicab(player_pos))
	
	if distance < 30: return
	elif distance < 200 and randi_range(1,2) != 1: return
	# Otherwise, spawn is guaranteed
	
	# Spawn the enemy 20 tiles away from the player.
	# If you're closer to spawn, enemies will tend to come from the opposite direction to spawn.
	var angle_randomization = distance / 60.
	var tile: Vector2 = (player_pos + Vector2.from_angle(player_pos.angle_to_point(Vector2.ZERO)+PI+randf_range(-angle_randomization,angle_randomization)) * 20.)
	var enemy: Enemy
	var biome = get_biome(tile)
	if biome == Biome.EMPTINESS:
		enemy = preload("res://entities/enemies/VoidEnemy.tscn").instantiate()
	elif biome == Biome.PEACE or current_biome == Biome.EMPTINESS: return
	else:
		enemy = world_enemy(current_biome, distance)
	enemy.position = tile * 20.
	world_enemies += 1
	enemy.despawn.connect(func(): world_enemies -= 1)
	enemy.die.connect(func(): world_enemies -= 1)
	$Entities.add_child(enemy)

func _physics_process(_delta: float) -> void:
	var biome: Biome = get_biome(tile_at(Micro.player.position))
	if biome == current_biome: return
	current_biome = biome
	
	# Biome effects
	if current_biome == Biome.EMPTINESS:
		$EmptinessDamage.start()
		Micro.player.get_node("Camera/GlobalParticles/Emptiness").emitting = true
	else:
		$EmptinessDamage.stop()
		Micro.player.get_node("Camera/GlobalParticles/Emptiness").emitting = false
		match current_biome:
			Biome.PEACE:
				change_bg("peace")
			Biome.LANDING:
				change_bg("landing")
			_:
				change_bg("default")
	
	Micro.player.get_node("Camera/GlobalParticles/Peace").emitting = (current_biome == Biome.PEACE)

func _on_emptiness_damage_timeout() -> void:
	Micro.player.damage(1, true)

@warning_ignore("unused_signal")
signal refresh_trades
@warning_ignore("unused_signal")
signal purchase_upgrade(item: Upgrade)
@warning_ignore("unused_signal")
signal upgrade_purchased

var houses: Array[Vector2i] = [Vector2i(0,15),Vector2i(15,0),Vector2i(0,-15),Vector2i(-15,0)]

func tile_at(pos: Vector2) -> Vector2i:
	return round(pos / 20.)

func taxicab(pos: Vector2) -> float:
	return abs(pos.x) + abs(pos.y)

func get_biome(pos: Vector2i) -> Biome:
	var taxicab_distance: int = int(taxicab(pos))
	if taxicab_distance <= 64:
		return Biome.LANDING
	elif taxicab_distance >= 512:
		return Biome.EMPTINESS
	else:
		var center := biome_center_at(pos)
		if biomes.has(center):
			return biomes.get(center)
		return Biome.DEFAULT

func change_bg(new_effect: String):
	var effects := ["landing", "default", "peace", "placeholder"]
	var tween := create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	for effect in effects:
		if effect == new_effect:
			tween.parallel().tween_property($Background.material, "shader_parameter/%s_effect" % effect, 1., 1.)
		else:
			tween.parallel().tween_property($Background.material, "shader_parameter/%s_effect" % effect, 0., 1.)

# --------------
# World gen code
# --------------

func generate_world():
	await Micro.worldgen_status("Shaping biomes...")
	$BiomeMap/ColorRect.material.set("shader_parameter/seed", world_seed)
	$BiomeMap.render_target_update_mode = SubViewport.UPDATE_ONCE
	var biome_texture: ViewportTexture = $BiomeMap.get_texture()
	await RenderingServer.frame_post_draw
	biome_map = biome_texture.get_image()
	if Micro.get_config("debug", "save_biome_map", false):
		ResourceSaver.save(ImageTexture.create_from_image(biome_map), "user://biome_map.png")
		print("Saved biome map to user folder.")
	await Micro.worldgen_status("Placing traders...")
	var starting_traders_to_place := 2
	var opportunities := 4
	for dir in [Vector2i(1,1),Vector2i(1,-1),Vector2i(-1,-1),Vector2i(-1,1)]:
		opportunities -= 1
		if starting_traders_to_place == 0 or (random.randi_range(0,1)==1 and opportunities >= starting_traders_to_place):
			continue
		starting_traders_to_place -= 1
		var distance := 80
		while !attempt_decide_biome_for_center_structure(dir*distance, Biome.PEACE, 10):
			distance += 10
		var location := biome_center_at(dir*distance)
		place("trader_miniboss_arena", location, true)
		var miniboss := preload("res://entities/tiles/EnemyPosition.tscn").instantiate()
		miniboss.enemy = preload("res://entities/enemies/TraderMiniboss.tscn")
		miniboss.spawn_radius = 140.
		miniboss.hit_only = true
		miniboss.require_close = true
		miniboss.size = 50.
		miniboss.position = location * 20.
		$Entities.add_child(miniboss)
		place("anchor_room", Vector2i(Vector2(location).move_toward(Vector2.ZERO, 20).round()), true)
		var magnitude := int(location.length()) - 30
		while magnitude > 50:
			magnitude -= random.randi_range(15,20)
			place("guiding_light", Vector2i((Vector2(location).normalized()*magnitude).round()), true)
		var trader_location := Vector2i((Vector2(location).normalized()*40).round())
		place("small_house", trader_location, true)
		place("guiding_light", Vector2i((Vector2(location).normalized()*25).round()), false)
		
		var trader := preload("res://entities/Trader.tscn").instantiate()
		trader.position = trader_location * 20.
		trader.wander_range = 70.
		trader.wander_distance = 60.
		$Entities.add_child(trader)
	await Micro.worldgen_status("Scattering features...")
	var disks := VariablePoissonDiskSampler2D.new(random, Vector2(1000, 1000), 30)
	disks.generate(
		func (pos):
			match get_biome(pos):
				Biome.PEACE: return 30
				_: return 10
	, 5, 30)
	await Micro.worldgen_status("Placing features...")
	for pos in disks.samples:
		var tile := Vector2i(pos - Vector2(500, 500))
		if abs(tile.x) + abs(tile.y) > 510:
			continue
		if $Structures/NewTiles.get_cell_source_id(tile) > -1:
			continue
		match get_biome(tile):
			Biome.LANDING:
				place("cache", tile)
			Biome.DEFAULT when random.randf()>.5-biome_edgeness_at(tile):
				var obstacles := RollWeights.new()
				obstacles.add_items(["block", "cross", "thru", "thru2"], 2)
				obstacles.add_items(["select", "select_r1", "select_r2"], 3)
				obstacles.add_items(["diagonal", "diagonal2"], 5)
				obstacles.add_items(["line", "line2", "line_r1", "line_r2", "line2_r1", "line2_r2"], 2)
				place("obstacles/%s" % Micro.roll(obstacles), tile)
			Biome.DEFAULT when random.randf()>0.5:
				place("cache", tile)

func place(id: String, pos: Vector2i, force := false):
	var pattern: TileMapPattern = load("res://world/patterns/%s.tres" % id)
	var origin := pos-pattern.get_size()/2
	if !force:
		for cell in pattern.get_used_cells():
			if $Structures/NewTiles.get_cell_source_id(origin + cell) > -1:
				return
	for cell in pattern.get_used_cells():
		$Structures/NewTiles.set_cell(origin + cell,
			pattern.get_cell_source_id(cell),
			pattern.get_cell_atlas_coords(cell),
			pattern.get_cell_alternative_tile(cell)
		)

# Returns false if we fail
func attempt_decide_biome_for_center_structure(tile: Vector2i, biome: Biome, margin: int) -> bool:
	var center := biome_center_at(tile)
	# We'll be placing a structure at the center, so we can't have it be too close to spawn or the Emptiness
	if (abs(center.x) + abs(center.y) <= 80+margin) or (abs(center.x) + abs(center.y)) >= 512-margin:
		return false
	# Don't place it here if there's already a biome
	if biomes.has(center): return false
	biomes.set(center, biome)
	return true

func biome_center_at(tile: Vector2i) -> Vector2i:
	var color := biome_map.get_pixel(tile.x + 512, tile.y + 512)
	var uv: Vector2i = Vector2(color.r, color.g) * 1024
	return uv - Vector2i(512,512)

func biome_edgeness_at(tile: Vector2i) -> float:
	return biome_map.get_pixel(tile.x + 512, tile.y + 512).b
