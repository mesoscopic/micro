extends Node

# The Micro singleton

const SETTINGS = preload("res://scenes/ui/Settings.tscn")
var menu: Node
var player: Player
var world: World

var loaded_settings = {
	"photosensitive_mode": false
}

func screen_wipe_out():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_out")
	await SCREEN_WIPE_ANIMATOR.animation_finished

func screen_wipe_in():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_in")
	await SCREEN_WIPE_ANIMATOR.animation_finished
	SCREEN_WIPE_ANIMATOR.play("RESET")

func _input(event):
	if event.is_action_pressed("debug_overlay"):
		var overlay: Control = get_tree().current_scene.get_node("UI/DebugOverlay")
		overlay.visible = !overlay.visible

func settings(modal: bool):
	if is_instance_valid(menu): return
	menu = SETTINGS.instantiate()
	get_tree().current_scene.find_child("UI").add_child(menu)
	if modal: menu.be_modal()
	await menu.done

func wait(time: float):
	await get_tree().create_timer(time).timeout
