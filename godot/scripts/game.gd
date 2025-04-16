extends Node2D

class_name World

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var world_seed: int = randi()

var bosses_active: int = 0

func world_enemy(taxicab_distance: float) -> Enemy:
	var enemies: RollWeights = RollWeights.new()
	enemies.add_item(preload("res://scenes/characters/enemies/BasicShooter.tscn"), 4)
	if taxicab_distance >= 100:
		enemies.add_item(preload("res://scenes/characters/enemies/Turret.tscn"), 2)
		enemies.add_item(preload("res://scenes/characters/enemies/Teleporter.tscn"), 1)
	return Micro.roll(enemies).instantiate()

func spawn_attempt() -> void:
	if bosses_active > 0:
		print("a boss is active!")
		return # World enemies shouldn't spawn during boss fights
	var player_pos: Vector2 = Micro.player.position / 20.
	var taxicab_distance: float = abs(player_pos.x) + abs(player_pos.y)
	if taxicab_distance < 30:
		print("failed distance!")
		return # Make sure the player is far enough from spawn
	elif taxicab_distance < 60 and randi_range(1,2) != 1:
		print("failed chance! (1 in 2)")
		return # 1 in 2 chance to spawn if <80 tiles from spawn
	elif taxicab_distance < 100 and randi_range(1,3) == 1:
		print("failed chance! (2 in 3)")
		return # 2 in 3 chance to spawn if >80 and <160 tiles from spawn
	# Otherwise, spawn is guaranteed
	var enemy := world_enemy(taxicab_distance)
	# Spawn the enemy 20 tiles away from the player.
	# If you're closer to spawn, enemies will tend to come from the opposite direction to spawn.
	var angle_randomization = taxicab_distance / 60.
	var tile: Vector2 = (player_pos + Vector2.from_angle(player_pos.angle_to_point(Vector2.ZERO)+PI+randf_range(-angle_randomization,angle_randomization)) * 20.)
	enemy.position = tile * 20.
	$Structures.add_child(enemy)
	print("spawned an enemy at %s!" % tile)

const TRADER = preload("res://scenes/characters/Trader.tscn")

func get_trader(from: Vector2):
	var trader = TRADER.instantiate()
	trader.position = from.normalized()*160.
	$Structures.call_deferred("add_child", trader)
	Micro.refresh_trades.emit()

# --------------
# World gen code
# --------------

const BasicCache := preload("res://scenes/characters/tiles/Cache.tscn")

func generate_world():
	var start = Time.get_ticks_usec()
	Micro.worldgen_status("Placing caches...")
	for i in 200:
		var pos = Vector2(randfn(0., 3.), randfn(0., 3.)) * 20.
		pos += pos.normalized()*18.
		place(structure_at(BasicCache, round(pos)))
	print("world gen took %s microseconds" % (Time.get_ticks_usec()-start))

func structure_at(structure: PackedScene, pos: Vector2) -> Node2D:
	var build = structure.instantiate()
	build.position = pos*20.
	return build

func place(thing: Node2D):
	$Structures.add_child(thing)
