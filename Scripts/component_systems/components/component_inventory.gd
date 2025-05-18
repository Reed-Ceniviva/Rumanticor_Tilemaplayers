extends Resource
class_name component_inventory

@export var max_capacity: int = 100
var items: Dictionary = {}

func setup(capacity: int = 100):
	max_capacity = capacity
	items = {}

func add_item(item_name: String, amount: int = 1) -> bool:
	if get_total_items() + amount > max_capacity:
		return false
	items[item_name] = items.get(item_name, 0) + amount
	return true

func remove_item(item_name: String, amount: int = 1) -> bool:
	if not items.has(item_name) or items[item_name] < amount:
		return false
	items[item_name] -= amount
	if items[item_name] <= 0:
		items.erase(item_name)
	return true

func get_item_count(item_name: String) -> int:
	return items.get(item_name, 0)
	
func get_free_space() -> int:
	return max_capacity - get_total_items()

func get_total_items() -> int:
	var total = 0
	for value in items.values():
		total += value
	return total

func has_item(item_name: String, amount: int = 1) -> bool:
	return get_item_count(item_name) >= amount
