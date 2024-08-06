@tool
extends Node2D

@export var color: Color
@export var height: float
@export var width: float
@export var thickness: float


func to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	for coord in coords:
		array.append(Vector2(coord[0], coord[1]))
	return array

func _process(_delta):
	queue_redraw()

func _draw():
	var coords : Array = [
		[-width/2, -height/2],
		[width/2, -height/2],
		[width/2, height/2],
		[-width/2, height/2],
		[-width/2, -height/2]
	]
	draw_polyline(to_Vector2Array(coords), color, thickness)
