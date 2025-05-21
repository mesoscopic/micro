@icon("res://assets/icons/micro.svg")
@tool
## A blank texture for shader rendering.
class_name CharacterTexture extends ImageTexture

func _init():
	var image := Image.create_empty(1, 1, false, Image.FORMAT_RGBA8)
	image.set_pixel(0, 0, Color.WHITE)
	set_image(image)
