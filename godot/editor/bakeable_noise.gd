@tool
class_name BakeableNoiseTexture2D
extends NoiseTexture2D

@export var bake_path: String = ""

@export_tool_button("Bake!", "NoiseTexture2D")
var bake := func():
	self.get_image().save_png(bake_path)
