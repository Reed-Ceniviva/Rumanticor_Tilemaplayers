extends task
class_name task_locate_tree

func execute(entity) -> bool:
	print("attempting locate tree")
	var sight_component : component_sight = entity.get_meta("component_sight")
	var manager : layer_manager = entity.my_layer_manager
	if not sight_component or not manager:
		print("no sight component found")
		return false
	
	var current_pos : Vector2i = entity.map_location
	
	#print(manager.tm_layers["trees"].get_used_cells())
	print("current pos : " , current_pos , " | sight distance: " , sight_component.sight_distance)
	var trees = manager.get_non_empty_cells_in_radius("trees", current_pos, sight_component.sight_distance)
	print(trees)
	trees.erase(current_pos)
	
	if trees.size() > 0:
		sight_component.target_tile = sight_component.get_closest_point(current_pos, trees)
		return true
	print("no tree found")
	return false
