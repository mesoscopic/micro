extends Control

signal finished
signal play
signal options

var disable_menu: bool = false

func _on_finished(_anim_name):
	finished.emit()

func _on_play():
	if disable_menu: return
	disable_menu = true
	await Micro.screen_wipe_out()
	play.emit()

func _on_options():
	if disable_menu: return
	disable_menu = true
	await Micro.screen_wipe_out()
	await get_tree().current_scene.options()
	disable_menu = false

func _on_quit():
	if disable_menu: return
	get_tree().quit()
