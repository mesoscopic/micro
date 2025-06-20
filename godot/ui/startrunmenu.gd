extends Control

signal finished
signal play

var disable_menu: bool = false

func _ready() -> void:
	$Menu/VBoxContainer/Play.grab_focus()

func _on_button_hover(node: StringName) -> void:
	$Menu/VBoxContainer.find_child(node).grab_focus()

func _on_finished(_anim_name):
	finished.emit()

func _on_play():
	if disable_menu: return
	disable_menu = true
	Micro.worldgen_status("Instantiating world...")
	await Micro.screen_wipe_out()
	play.emit()

func _on_options():
	if disable_menu: return
	disable_menu = true
	await Micro.settings(true)
	disable_menu = false

func _on_quit():
	if disable_menu: return
	get_tree().quit()
