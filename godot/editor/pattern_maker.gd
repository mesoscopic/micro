@tool
extends TileMapLayer

@export var pattern_name := ""

@export_tool_button("Save as TileMapPattern", "TileSet") var save = func ():
	var pattern: TileMapPattern = get_pattern(get_used_cells())
	ResourceSaver.save(pattern, "res://world/patterns/%s.tres" % pattern_name)

@export_tool_button("Load TileMapPattern", "TileSet") var load = func ():
	var pattern: TileMapPattern = ResourceLoader.load("res://world/patterns/%s.tres" % pattern_name, "TileMapPattern")
	set_pattern(Vector2i.ZERO, pattern)
