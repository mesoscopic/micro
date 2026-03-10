@icon("res://assets/icons/micro.svg")
@tool
## A simple quad renderer for shader effects.
class_name Render extends Node2D

const QUAD := [Vector2(0., 0.), Vector2(1., 0.), Vector2(1., 1.), Vector2(0., 1.)]

func _draw() -> void:
	draw_primitive(
		[Vector2(-.5, -.5), Vector2(.5, -.5), Vector2(.5, .5), Vector2(-.5, .5)],
		[Color.WHITE, Color.WHITE, Color.WHITE, Color.WHITE],
		[Vector2(0., 0.), Vector2(1., 0.), Vector2(1., 1.), Vector2(0., 1.)]
	)
