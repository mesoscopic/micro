@tool
extends Node2D

@export var color: Color
@export var width: float
@export var height: float
@export var thickness: float
@export var lines: int


func to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	for coord in coords:
		array.append(Vector2(coord[0], coord[1]))
	return array

func _process(_delta):
	queue_redraw()

func _draw():
	for l in lines:
		var ratio = float(l)/float(lines) + 0.5/float(lines)
		draw_line(Vector2(width * fmod(ratio*2.0, 1.0) - width/2, -(height/2) if ratio < 0.5 else height/2), Vector2(-width/2 if ratio < 0.5 else width/2, height * fmod(ratio*2.0, 1.0) - height/2), color, thickness)
