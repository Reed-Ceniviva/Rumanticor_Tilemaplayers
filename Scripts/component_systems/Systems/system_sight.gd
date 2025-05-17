extends Node
class_name system_sight

var world_layer_manager

func _init(_world_layer_manager) -> void:
	world_layer_manager = _world_layer_manager

func locate_nearest_in(entity: Node2D, layer_name: String, distance: int = 0 )-> Vector2i:
	if not entity.has_meta("component_sight") or not entity.has_meta("component_movement"):
		return Vector2i(-1, -1)

	var sight : component_sight = entity.get_meta("component_sight")
	var movement : component_movement = entity.get_meta("component_movement")

	var map_location = world_layer_manager.tm_layers["ground"].local_to_map(entity.position)
	var non_empty_cells: Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius(layer_name, map_location, sight.sight_distance)
	non_empty_cells.erase(map_location)

	if non_empty_cells.is_empty():
		print("No non-empty tile in ", layer_name, " within distance: ", distance)
		return Vector2i(-1, -1)

	var target_cell = get_closest_point(map_location, non_empty_cells)
	sight.target_tile = target_cell
	return target_cell

func get_closest_point(origin: Vector2i, points: Array[Vector2i]) -> Vector2i:
	var closest = points[0]
	var min_dist = origin.distance_squared_to(closest)

	for point in points:
		var dist = origin.distance_squared_to(point)
		if dist < min_dist:
			min_dist = dist
			closest = point

	return closest
