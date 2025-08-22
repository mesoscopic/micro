extends Resource
class_name VariablePoissonDiskSampler2D

# Code adapted from https://github.com/ssell/VariablePoissonSampler
# The C# implementation uses the MIT license.
# Copyright (c) 2021 Steven Sell 

var generating: bool
var samples: PackedVector2Array
var size: Vector2
var attempts: int
var rng: RandomNumberGenerator
var grid: SpatialGrid2D
var active_list: PackedInt32Array

func _init(random: RandomNumberGenerator, domain_size: Vector2, max_attempts: int):
	rng = random
	size = domain_size
	attempts = max_attempts

func generate(radius_function: Callable, min_radius: float, max_radius: float) -> bool:
	if generating:
		return false
	initialize(min_radius, max_radius)
	generate_first_point()
	while len(active_list) > 0:
		var sample_found := false
		var active_index := get_random_active_list_index()
		var current_sample: Vector2 = samples[active_list[active_index]]
		for i in range(attempts):
			var radius: float = radius_function.call(current_sample)
			var random_sample: Vector2 = generate_random_point_in_annulus(current_sample, radius)
			
			if grid.add_if_open(len(samples), random_sample, radius):
				add_sample(random_sample)
				sample_found = true
				break
		if !sample_found:
			active_list.remove_at(active_index)
	generating = false
	return true

func initialize(min_radius: float, max_radius: float):
	generating = true
	grid = SpatialGrid2D.new(size, min_radius, max_radius)
	active_list = PackedInt32Array()
	samples = PackedVector2Array()

func generate_first_point():
	var sample := Vector2(rng.randf() * size.x, rng.randf() * size.y)
	add_sample(sample)

func add_sample(sample: Vector2):
	var sample_index: int = len(samples)
	samples.append(sample)
	active_list.append(sample_index)

func get_random_active_list_index() -> int:
	return rng.randi_range(0, len(active_list) - 1)

func generate_random_point_in_annulus(point: Vector2, radius: float) -> Vector2:
	var minimum := radius
	var maximum := radius * 2.
	var distance: float = rng.randf() * (maximum - minimum) + minimum
	var angle: float = rng.randf() * PI * 2.
	return point + Vector2.from_angle(angle) * distance

class SpatialGrid2D:
	var size: Vector2
	var cell_length: float
	var cell_count: Vector2i
	var cells: Array[SpatialCell] = []
	var items: PackedInt32Array = PackedInt32Array()
	
	func _init(s: Vector2, min_radius: float, max_radius: float):
		size = s
		cell_length = ((min_radius + max_radius)*0.5)/sqrt(2)
		cell_count = Vector2i(ceil(size.x / cell_length), ceil(size.y / cell_length))
		for y: int in range(cell_count.y):
			for x: int in range(cell_count.x):
				cells.append(SpatialCell.new(x, y, cell_length))
	
	func add(item: int, pos: Vector2, radius: float):
		var index: int = get_index(pos)
		if index == -1:
			return false
		add_index(item, index, pos, radius)
		return true
	
	func add_if_open(item: int, pos: Vector2, radius: float):
		var index: int = get_index(pos)
		if !is_open_index(index, pos, radius):
			return false
		add_index(item, index, pos, radius)
		return true
	
	func add_index(item: int, index: int, pos: Vector2, radius: float):
		var cell_radius: int = ceil(radius / cell_length)
		var item_index: int = len(items)
		items.append(item)
		var spatial_item := SpatialGridItem.new(item_index, pos, radius)
		for iy: int in range(-cell_radius, cell_radius + 1):
			for ix: int in range(-cell_radius, cell_radius + 1):
				var neighbor: int = index + ix + iy * cell_count.x
				if neighbor < 0 or neighbor >= len(cells):
					continue
				if cells[neighbor].intersects_cell(pos.x, pos.y, radius):
					cells[neighbor].contents.append(spatial_item)
	
	func remove(item: int):
		var index: int = 0
		while index < len(items):
			if items[index] == item:
				items.remove_at(index)
				break
			index += 1
		for i: int in range(len(cells)):
			var cell: SpatialCell = cells[i]
			for j: int in range(len(cell.contents)):
				var rj: int = len(cell.contents) - j - 1
				if cell.contents[rj].index == index:
					cell.contents.remove_at(rj)
	
	func clear():
		items.clear()
		for cell in cells:
			cell.contents.clear()
	
	func is_open(pos: Vector2, radius: float) -> bool:
		var center_index: int = get_index(pos)
		return is_open_index(center_index, pos, radius)
	
	func is_open_index(center_index: int, pos: Vector2, radius: float) -> bool:
		if center_index == -1:
			return false
		var cell_radius: int = ceil(radius / cell_length)
		for iy in range(-cell_radius, cell_radius + 1):
			for ix in range(-cell_radius, cell_radius + 1):
				var neighbor: int = center_index + ix + iy * cell_count.x
				if neighbor < 0 or neighbor >= len(cells):
					continue
				if cells[neighbor].intersects_cell(pos.x, pos.y, radius) and cells[neighbor].intersects_child(pos.x, pos.y, radius):
					return false
		return true
	
	func get_index(pos: Vector2) -> int:
		if pos.x < 0 or pos.x > size.x or pos.y < 0 or pos.y > size.y:
			return -1
		var dx := int(pos.x / cell_length)
		var dy := int(pos.y / cell_length)
		return dx + dy * cell_count.x
	
	func get_at(pos: Vector2, radius: float) -> PackedFloat32Array:
		var result := PackedFloat32Array()
		var cell_index: int = get_index(pos)
		if cell_index != -1:
			var grid_items := cells[cell_index].get_intersections(pos.x, pos.y, radius)
			for item in grid_items:
				result.append(items[item.index])
		return result

class SpatialCell:
	var offset: Vector2i
	var origin: Vector2
	var dimension: float
	var contents: Array[SpatialGridItem] = []
	
	func _init(x: int, y: int, dim: float):
		offset = Vector2i(x, y)
		origin = offset * dim
		dimension = dim
	
	func contains_point(x: float, y: float) -> bool:
		return (x >= origin.x) and (x < origin.x + dimension) and (y >= origin.y) and (y < origin.y + dimension)
	
	func intersects_cell(x: float, y: float, radius: float) -> bool:
		var closest := Vector2(clamp(x, origin.x, origin.x + dimension), clamp(y, origin.y, origin.y + dimension))
		var distance_squared := (Vector2(x, y) - closest).length_squared()
		return distance_squared < pow(radius, 2)
	
	func intersects_child(x: float, y: float, radius: float) -> bool:
		for item in contents:
			if Vector2(x, y).distance_squared_to(item.pos) < pow(radius, 2):
				return true
		return false
	
	func get_intersections(x: float, y: float, radius: float) -> Array[SpatialGridItem]:
		return contents.filter(func (item): return Vector2(x, y).distance_squared_to(item.pos) < pow(radius, 2))

class SpatialGridItem:
	var index: int
	var pos: Vector2
	var radius: float
	
	func _init(i: int, p: Vector2, r: float):
		index = i
		pos = p
		radius = r
