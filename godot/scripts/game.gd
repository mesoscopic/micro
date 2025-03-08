extends Node2D

class_name World

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var world_seed: int = randi()

func _ready():
	Micro.world = self
	random.seed = world_seed
	generate_world()
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
