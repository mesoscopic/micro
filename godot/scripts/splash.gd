extends Control

signal finished

func _on_finished(_anim_name):
	finished.emit()
