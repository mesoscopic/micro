extends Node

# The Micro singleton

var menu: Node
var player: Player
var world: World
var frozen := false

var config: ConfigFile
var settings_defaults: Dictionary[String, int] = {
	"photosensitive_mode": 0,
	"fullscreen": 1,
	"vsync": 1,
	"swap_joysticks": 0,
	"rumble": 2,
	"bg_alpha_percent": 5,
	"speedrun": 0
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
	elif event.is_action_pressed("debug_pause") and frozen == get_tree().paused:
		frozen = !(get_tree().paused)
		get_tree().paused = frozen
	elif event.is_action_pressed("debug_print"):
		print("\n== BREAK ==")
	elif event.is_action_pressed("debug_tp"):
		Micro.player.global_position = Micro.world.biomes.find_key(Micro.world.Biome.MINEFIELD) * 20. #get_tree().get_first_node_in_group("boss").global_position

func settings():
	var settings_menu := preload("res://ui/SettingsMenu.tscn").instantiate()
	get_tree().current_scene.get_node("UI").add_child(settings_menu)
	await settings_menu.done
	settings_menu.queue_free()

func wait(time: float, override_time: bool = false):
	await get_tree().create_timer(time, override_time, false, override_time).timeout

func freeze(time: float):
	if frozen: return
	frozen = true
	get_tree().paused = true
	await wait(time, true)
	if frozen == get_tree().paused:
		frozen = false
		get_tree().paused = false

func worldgen_status(status: String) -> void:
	print(status)
	get_tree().current_scene.get_node("ScreenWipe/StatusMessage").text = status
	await get_tree().process_frame

func show_trade_information(toll: Toll):
	var overlay = get_tree().current_scene.get_node("UI/TradeOverlay")
	overlay.get_node("Panel/Margin/HBoxContainer/VBoxContainer/ItemDisplay").material = toll.render
	overlay.get_node("Panel/Margin/HBoxContainer/VBoxContainer/MarginContainer/HBoxContainer/Cost").text = "%s" % (toll.cost - toll.balance)
	overlay.get_node("Panel/Margin/HBoxContainer/MarginContainer/VBoxContainer/Title").text = toll.title
	overlay.get_node("Panel/Margin/HBoxContainer/MarginContainer/VBoxContainer/Description").text = toll.description
	if !overlay.visible:
		overlay.get_node("Animations").play("show")
	else:
		overlay.get_node("Animations").play("keep_shown")

func hide_trading():
	get_tree().current_scene.get_node("UI/TradeOverlay/Animations").play("hide")

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

func get_config(category: String, id: String, default) -> Variant:
	if !config:
		config = ConfigFile.new()
		config.load("user://micro.cfg")
	return config.get_value(category, id, default)

func set_config(category: String, id: String, value) -> void:
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


func get_control(id: String) -> InputEvent:
	var control: String = get_config("controls", id, "")
	if control == "":
		return InputMap.action_get_events(id)[0]
	else:
		return deserialize_input(control)

func set_control(id: String, event: InputEvent, initial: bool = false):
	if !initial: set_config("controls", id, serialize_input(event))
	InputMap.action_erase_events(id)
	InputMap.action_add_event(id, event)

func serialize_input(event: InputEvent) -> String:
	if event is InputEventKey:
		return "key:%s:%s" % [event.physical_keycode, event.unicode]
	elif event is InputEventMouseButton:
		return "mouse:%s" % event.button_index
	elif event is InputEventJoypadButton:
		return "button:%s" % event.button_index
	elif event is InputEventJoypadMotion:
		return "axis:%s:%s" % [event.axis, event.axis_value]
	return ""

func deserialize_input(input: String) -> InputEvent:
	var split := input.split(":")
	var type := split[0]
	var code := int(split[1])
	var extra := split[2] if split.size() > 2 else ""
	var event: InputEvent
	match type:
		"key":
			event = InputEventKey.new()
			event.physical_keycode = code
			event.unicode = int(extra)
		"mouse":
			event = InputEventMouseButton.new()
			event.button_index = code
		"button":
			event = InputEventJoypadButton.new()
			event.button_index = code
		"axis":
			event = InputEventJoypadMotion.new()
			event.axis = code
			event.axis_value = float(extra)
	return event

func rumble(important: bool, time: float) -> void:
	if get_setting("rumble") == 0: return
	if len(Input.get_connected_joypads()) == 0: return
	var joy: int = Input.get_connected_joypads()[0]
	var weak := get_setting("rumble") == 1
	if important: Input.start_joy_vibration(joy, 1.0, 0.0 if weak else 1.0, time)
	elif get_setting("rumble") == 1: return
	else: Input.start_joy_vibration(joy, 1.0, 0.0, time)
 
var scenes: Dictionary[StringName, PackedScene] = {}

func load_scenes() -> void:
	scenes[&"micro:fund_coin"] = load("uid://bwsl01caneedv")
	scenes[&"micro:heal_orb"] = load("uid://degva33wjvowa")
	scenes[&"micro:bullet"] = load("uid://v7mv45nprvqq")
	scenes[&"micro:bullet_telegraphed"] = load("uid://bdgbhm7jvt6n2")
	scenes[&"micro:player_bullet"] = load("uid://dnrcdtyawedjb")
	scenes[&"micro:bullet_spawner"] = load("uid://tv3xkxmljps6")
	scenes[&"micro:bullet_laser"] = load("uid://clpbwn742hbdn")
	scenes[&"micro:bullet_homing"] = load("uid://by8vbrl6i7h4x")
	scenes[&"micro:bullet_bomb"] = load("uid://bbs436j75kwf1")
	scenes[&"micro:bullet_mine"] = load("uid://b3bagn8onbpyl")
	scenes[&"micro:trader"] = load("uid://cjt7tm6d5ow8j")
	scenes[&"micro:enemy_surprise"] = load("uid://5r4rapdj3ft")
	scenes[&"micro:enemy_tutorial"] = load("uid://c6om7rrvf38gu")
	scenes[&"micro:enemy_spread_shooter"] = load("uid://b46bcw3s1yhbg")
	scenes[&"micro:enemy_multi_shooter"] = load("uid://ij3bdhvutjdc")
	scenes[&"micro:enemy_turret"] = load("uid://c0qyylco7xgk4")
	scenes[&"micro:enemy_bomber"] = load("uid://dbm44iqln8ku")
	scenes[&"micro:enemy_teleporter"] = load("uid://cr70dq40ddv00")
	scenes[&"micro:enemy_surpriser"] = load("uid://da4uam7bgmyfs")
	scenes[&"micro:enemy_trader_miniboss"] = load("uid://degw88c3u4obt")
	scenes[&"micro:enemy_void"] = load("uid://b8xv4bx33kxeg")

func new(id: StringName) -> Node:
	return scenes[id].instantiate()
