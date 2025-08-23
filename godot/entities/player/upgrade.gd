extends Resource
class_name Upgrade

static var count_active: Dictionary[String, int] = {}

var cost: int
var title: String
var description: String
var render: ShaderMaterial

func enable() -> void:
	pass

func disable() -> void:
	pass

func _init() -> void:
	title = get_title()
	description = get_description()
	cost = get_cost(get_count(get_title()))
	render = ShaderMaterial.new()
	render.shader = get_shader()

static func add(kind: String) -> void:
	Micro.player.upgrades.set(kind, Micro.player.upgrades.get_or_add(kind, 0)+1)

static func remove(kind: String) -> void:
	Micro.player.upgrades.set(kind, Micro.player.upgrades.get_or_add(kind, 0)-1)

static func get_count(kind: String) -> int:
	return Micro.player.upgrades.get_or_add(kind, 0)

static func get_title() -> String:
	return "Upgrade"

static func get_description() -> String:
	return "Upgrades you"

static func get_shader() -> Shader:
	return preload("res://entities/player/player.gdshader")

func get_cost(_count: int) -> int:
	return 0
