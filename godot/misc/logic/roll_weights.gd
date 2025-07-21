extends Resource
class_name RollWeights

var weights: Array[int] = []
var items: Array[Variant] = []
var weights_array
var weights_sum: int = 0

func add_item(item: Variant, weight: int) -> RollWeights:
	weights.push_back(weight)
	items.push_back(item)
	weights_sum += weight
	return self

func add_items(item_list: Array, weight: int) -> RollWeights:
	for item in item_list:
		add_item(item, weight)
	return self

func get_item(roll: int) -> Variant:
	for i in weights.size():
		roll -= weights[i]
		if roll <= 0:
			return items[i]
	# Failsafe to make the typechecker happy
	return items[0]
