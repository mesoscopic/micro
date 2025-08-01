extends Node

# The Micro singleton

var menu: Node
var player: Player
var world: World
var debug_paused := false

var config: ConfigFile
var settings_defaults: Dictionary[String, int] = {
	"photosensitive_mode": 0,
	"fullscreen": 1,
	"vsync": 1,
	"swap_joysticks": 0,
	"rumble": 2
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
	elif event.is_action_pressed("debug_print"):
		print("\n== BREAK ==")
	elif event.is_action_pressed("debug_tp"):
		Micro.player.global_position = get_tree().get_first_node_in_group("boss").global_position

func settings():
	var settings_menu := preload("res://ui/SettingsMenu.tscn").instantiate()
	get_tree().current_scene.get_node("UI").add_child(settings_menu)
	await settings_menu.done
	settings_menu.queue_free()

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

func get_config(category: String, id: String, default: int) -> int:
	if !config:
		config = ConfigFile.new()
		config.load("user://micro.cfg")
	return config.get_value(category, id, default)

func set_config(category: String, id: String, value: int) -> void:
	if !config:
		config = ConfigFile.new()
		config.load("user://micro.cfg")
	config.set_value(category, id, value)
	config.save("user://micro.cfg")

func get_setting(id: String) -> int:
	var default: Variant = settings_defaults.get(id)
	if typeof(default) == TYPE_NIL: default = 0
	return get_config("settings", id, default)

func set_setting(id: String, value: int) -> void:
	set_config("settings", id, value)
	get_tree().current_scene.setting_hook(id, value)

func rumble(important: bool, time: float) -> void:
	if get_setting("rumble") == 0: return
	if len(Input.get_connected_joypads()) == 0: return
	var joy: int = Input.get_connected_joypads()[0]
	var weak := get_setting("rumble") == 1
	if important: Input.start_joy_vibration(joy, 1.0, 0.0 if weak else 1.0, time)
	elif get_setting("rumble") == 1: return
	else: Input.start_joy_vibration(joy, 1.0, 0.0, time)
