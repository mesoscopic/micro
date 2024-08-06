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
		draw_line(Vector2(-(width/2), -(height/2) + float(height)/float(lines)/2 + height*float(l)/float(lines)), Vector2(width/2, -(height/2) + float(height)/float(lines)/2 + height*float(l)/float(lines)), color, thickness)
