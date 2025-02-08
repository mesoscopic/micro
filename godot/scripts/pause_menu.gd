extends Control

var disable_menu: bool = false

signal finished

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("open_menu"):
		exit()

func _ready() -> void:
	$Menu/VBoxContainer/Resume.grab_focus()

func _on_button_hover(node: StringName) -> void:
	$Menu/VBoxContainer.find_child(node).grab_focus()

func _on_resume() -> void:
	exit()

func _on_options():
	if disable_menu: return
	disable_menu = true
	await Micro.settings(true)
	disable_menu = false

func _on_quit():
	if disable_menu: return
	get_tree().quit()

func exit():
	if disable_menu: return
	finished.emit()
	disable_menu = true
	create_tween().tween_property(self, "modulate", Color.TRANSPARENT, 0.1)
	await Micro.wait(0.15)
	queue_free()
