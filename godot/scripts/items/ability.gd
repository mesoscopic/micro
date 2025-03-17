extends Node2D

class_name Ability

@onready var player: Player = get_parent().get_parent()
@export var timer: Timer

signal trigger
signal cooldown_end

func _ready():
	timer.timeout.connect(cooldown_end.emit)

func activate():
	if available():
		trigger.emit()

func available() -> bool:
	return timer.is_stopped()
