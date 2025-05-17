extends Resource
class_name component_sight

@export var sight_distance: int = 32
var target_tile: Vector2i = Vector2i(-1,-1)

func setup(sight: int = 0):
	sight_distance = sight
