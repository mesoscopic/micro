extends Node2D

class_name AggroMethod

signal aggro_changed

var is_aggro: bool = false
@onready var parent: Enemy = get_parent()

func aggro():
	var was_aggro = is_aggro
	is_aggro = true
	if !was_aggro: aggro_changed.emit(self)

func deaggro():
	var was_aggro = is_aggro
	is_aggro = false
	if was_aggro: aggro_changed.emit(self)
