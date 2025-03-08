extends Node2D

class_name Ability

@onready var player: Player = get_parent().get_parent()

signal trigger

func activate():
	trigger.emit()
