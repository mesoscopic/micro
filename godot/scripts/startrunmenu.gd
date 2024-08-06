extends Control

signal finished
signal play

var disable_menu: bool = false

func _on_finished(_anim_name):
	finished.emit()
	$Menu/VBoxContainer/Play.grab_focus()

func _on_play():
	if disable_menu: return
	disable_menu = true
	await Micro.screen_wipe_out()
	play.emit()

func _on_options():
	if disable_menu: return
	pass # not made yet

func _on_quit():
	if disable_menu: return
	get_tree().quit()
