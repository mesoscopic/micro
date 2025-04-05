extends Node2D

class_name World

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var world_seed: int = randi()

func spawn_attempt() -> void:
	var player_pos: Vector2 = Micro.player.position / 20.
	var taxicab_distance: float = abs(player_pos.x) + abs(player_pos.y)
	if taxicab_distance < 30:
		print("failed distance!")
		return # Make sure the player is far enough from spawn
	elif taxicab_distance < 60 and randi_range(1,3) != 1:
		print("failed chance! (1 in 3)")
		return # 1 in 3 chance to spawn if <60 tiles from spawn
	elif taxicab_distance < 150 and randi_range(1,2) != 1:
		print("failed chance! (1 in 2)")
		return # 1 in 2 chance to spawn if >60 and <150 tiles from spawn
	# Otherwise, spawn is guaranteed
	var enemies: RollWeights = RollWeights.new()
	enemies.add_item(preload("res://scenes/characters/enemies/BasicShooter.tscn"), 1)
	var enemy: Enemy = Micro.roll(enemies).instantiate()
	# Spawn the enemy 20 tiles away from the player.
	# If you're closer to spawn, enemies will tend to come from the opposite direction to spawn.
	var angle_randomization = taxicab_distance / 50.
	var tile: Vector2 = (player_pos + Vector2.from_angle(player_pos.angle_to(Vector2.ZERO)+PI+randf_range(-angle_randomization,angle_randomization)) * 20.)
	enemy.position = tile * 20.
	$Structures.add_child(enemy)
	print("spawned an enemy at %s!" % tile)
	

# --------------
# World gen code
# --------------

var ItemShrine := preload("res://scenes/structures/ItemShrine.tscn")

func generate_world():
	place(structure_at(ItemShrine, Vector2(0,16)))
	place(structure_at(ItemShrine, Vector2(0,-16)))
	place(structure_at(ItemShrine, Vector2(16,0)))
	place(structure_at(ItemShrine, Vector2(-16,0)))

func structure_at(structure: PackedScene, pos: Vector2) -> Node2D:
	var build = structure.instantiate()
	build.position = pos*20.
	return build

func place(thing: Node2D):
	$Structures.add_child(thing)
