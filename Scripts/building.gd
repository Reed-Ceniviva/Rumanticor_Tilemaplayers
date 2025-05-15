class_name building extends Node

var location : Vector2i 
var max_inventory = 5

var inventory : Dictionary = {
	"wood": 0,
	"stone": 0,
	"food": 0,
	"drink": 0,
	"beds": 0
}

func _init(starting_location : Vector2i):
	location = starting_location

func _ready():
	pass
	
	
func get_inventory(inventory_type : String) -> int:
	if inventory.has(inventory_type):
		return inventory[inventory_type]
	else:
		print("invalid inventory call for: " , inventory_type)
		return 0

func insert_inventory(inventory_type : String, value : int):
	if inventory.has(inventory_type):
		inventory[inventory_type] += value
		if inventory[inventory_type] > max_inventory:
			var overflow = inventory[inventory_type] - max_inventory
			inventory[inventory_type] = max_inventory
			return overflow
		else:
			return 0
		print("building now has: " , inventory[inventory_type], " logs")
	else:
		return value
