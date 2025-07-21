@tool
extends TileMapLayer

@export var pattern_name := ""

@export_tool_button("Save as TileMapPattern", "TileSet") var save = func ():
	var pattern: TileMapPattern = get_pattern(get_used_cells())
	ResourceSaver.save(pattern, "res://world/patterns/%s.tres" % pattern_name)
