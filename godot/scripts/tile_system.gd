extends TileMapLayer

enum TileType {
	FLOOR,
	WALL,
	CACHE
}
	
var tile_info: Dictionary[TileType, TileInfo] = {
	TileType.FLOOR: TileInfo.new(0, Vector2i.ZERO, 0),
	TileType.WALL: TileInfo.new(0, Vector2i(1, 0), 0),
	TileType.CACHE: TileInfo.new(1, Vector2i.ZERO, 1)
}

func is_open(tile: Vector2i) -> bool:
	return get_cell_source_id(tile) == -1

func try_place(kind: String, tile: Vector2i):
	if is_open(tile):
		place_tile(kind, tile)

func place_tile(kind: String, tile: Vector2i):
	var type: TileType = TileType.get(kind)
	var info: TileInfo = tile_info.get(type)
	set_cell(tile, info.source, info.coord, info.variant)

class TileInfo:
	var source: int
	var coord: Vector2i
	var variant: int
	
	func _init(s: int, c: Vector2i, v: int):
		source = s
		coord = c
		variant = v
