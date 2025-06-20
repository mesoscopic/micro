extends Node

# The Micro singleton

const SETTINGS = preload("res://ui/Settings.tscn")
var menu: Node
var player: Player
var world: World
var debug_paused := false

var config: ConfigFile
var settings_defaults := {
	"photosensitive_mode": false
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func screen_wipe_out():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_out")
	await SCREEN_WIPE_ANIMATOR.animation_finished

func screen_wipe_in():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_in")
	await SCREEN_WIPE_ANIMATOR.animation_finished
	SCREEN_WIPE_ANIMATOR.play("RESET")
	get_tree().current_scene.get_node("ScreenWipe/StatusMessage").text = ""

func _input(event):
	if event.is_action_pressed("debug_overlay"):
		var overlay: Control = get_tree().current_scene.get_node("UI/DebugOverlay")
		overlay.visible = !overlay.visible
	elif event.is_action_pressed("debug_pause") and debug_paused == get_tree().paused:
		debug_paused = !(get_tree().paused)
		get_tree().paused = debug_paused

func settings(modal: bool):
	if is_instance_valid(menu): return
	menu = SETTINGS.instantiate()
	get_tree().current_scene.find_child("UI").add_child(menu)
	if modal: menu.be_modal()
	await menu.done

func wait(time: float, override_time: bool = false):
	await get_tree().create_timer(time, override_time, false, override_time).timeout

func worldgen_status(status: String) -> void:
	print(status)
	get_tree().current_scene.get_node("ScreenWipe/StatusMessage").text = status
	await get_tree().process_frame

func show_trade_information(trader: Trader):
	var overlay = get_tree().current_scene.get_node("UI/TradeOverlay")
	overlay.get_node("HBoxContainer/Trader/VBoxContainer/ItemDisplay").material = trader.item.render
	overlay.get_node("HBoxContainer/Trader/VBoxContainer/MarginContainer/HBoxContainer/Cost").text = "%s" % trader.item.cost
	overlay.get_node("HBoxContainer/MarginContainer/VBoxContainer/Title").text = trader.item.title
	overlay.get_node("HBoxContainer/MarginContainer/VBoxContainer/Description").text = trader.item.description
	if !overlay.visible:
		overlay.get_node("Animations").play("show")
	else:
		overlay.get_node("Animations").play("keep_shown")

func hide_trading():
	get_tree().current_scene.get_node("UI/TradeOverlay/Animations").play("hide")

func attempt_trade(trader: Trader):
	var overlay = get_tree().current_scene.get_node("UI/TradeOverlay")
	var item = trader.item
	if Micro.player.funds < item.cost:
		overlay.get_node("Animations").play("cannot_afford")
	else:
		overlay.get_node("Animations").play("hide")
		world.trade(trader, item)

func roll(weights: RollWeights) -> Variant:
	var random: RandomNumberGenerator
	if Micro.world:
		random = Micro.world.random
	else:
		random = RandomNumberGenerator.new()
	
	var choice: int = randi_range(1, weights.weights_sum)
	return weights.get_item(choice)

func closest_enemy(to: Vector2) -> Enemy:
	var closest: Enemy = null
	for enemy in get_tree().get_nodes_in_group("enemy").filter(func (enemy): return to.distance_squared_to(enemy.global_position)<57600):
		if enemy is Enemy: # which it should be
			if !closest or to.distance_squared_to(enemy.global_position)<to.distance_squared_to(closest.global_position):
				closest = enemy
	return closest

func config_field(category: String, id: String, default: Variant, value: Variant = null) -> Variant:
	if !config:
		config = ConfigFile.new()
		config.load("user://micro.cfg")
	if value:
		config.set_value(category, id, value)
		return config.save("user://micro.cfg")
	else:
		return config.get_value(category, id, default)

func setting(id: String, value: Variant = null) -> Variant:
	return config_field("settings", id, settings_defaults.get(id), value)
