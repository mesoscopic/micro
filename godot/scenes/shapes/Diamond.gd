@tool
extends Node2D

@export var color: Color
@export var radius: float
@export_range(0, 1) var fill: float


func to_Vector2Array(coords : Array) -> PackedVector2Array:
	# Convert the array of floats into a PackedVector2Array.
	var array : PackedVector2Array = []
	for coord in coords:
		array.append(Vector2(coord[0], coord[1]))
	return array

func _process(_delta):
	queue_redraw()

func _draw():
	var thickness = radius*fill
	var out = radius - thickness/2
	var coords : Array = [
		[0, out],
		[out, 0],
		[0, -out],
		[-out, 0],
		[0, out]
	]
	draw_polyline(to_Vector2Array(coords), color, sqrt(thickness**2/2))
