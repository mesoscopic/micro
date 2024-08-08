extends Node

# The Micro singleton

func screen_wipe_out():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/Layer/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_out")
	await SCREEN_WIPE_ANIMATOR.animation_finished

func screen_wipe_in():
	var SCREEN_WIPE_ANIMATOR = get_tree().current_scene.get_node("ScreenWipe/Layer/ScreenWipeAnimation")
	SCREEN_WIPE_ANIMATOR.play("wipe_in")
	await SCREEN_WIPE_ANIMATOR.animation_finished
	SCREEN_WIPE_ANIMATOR.play("RESET")

func _input(event):
	if event.is_action_pressed("debug_overlay"):
		var overlay: Control = get_tree().current_scene.get_node("UI/DebugOverlay")
		overlay.visible = !overlay.visible
