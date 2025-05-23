extends task
class_name task_locate_random_traversable_tile

func execute(entity) -> bool:
	task_type = "locate_tree"
	print("attempting locate traversable tile")
	var sight_component : component_sight = entity.get_meta("component_sight")
	var manager : layer_manager = entity.my_layer_manager
	if not sight_component or not manager:
		print("no sight component found")
		return false
	
	var current_pos : Vector2i = entity.map_location
	
	#print(manager.tm_layers["trees"].get_used_cells())
	#print("current pos : " , current_pos , " | sight distance: " , sight_component.sight_distance)
	var traversable_tiles = manager.get_non_empty_cells_in_radius("trees", current_pos, 1)
	print(traversable_tiles)
	traversable_tiles.erase(current_pos)
	
	if traversable_tiles.size() > 0:
		sight_component.target_tile = sight_component.get_closest_point(current_pos, traversable_tiles)
		return true
	print("no traversable_tiles found")
	return false
