extends task
class_name task_locate_tree

func execute(entity) -> bool:
	var sight_component : component_sight = entity.get_meta("component_sight")
	var manager : layer_manager = entity.my_layer_manager
	if not sight_component or not manager:
		return false
	
	var current_pos : Vector2i = entity.map_location
	
	var trees = manager.get_non_empty_cells_in_radius("trees", current_pos, sight_component.sight_distance)
	trees.erase(current_pos)
	
	if trees.size() > 0:
		sight_component.target_tile = sight_component.get_closest_point(current_pos, trees)
		return true
	return false
