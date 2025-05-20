extends task
class_name task_locate_building_location

func execute(entity) -> bool:
	task_type = "locate_building_location"
	print("attempting locate building location")
	var sight_component : component_sight = entity.get_meta("component_sight")
	var manager : layer_manager = entity.my_layer_manager
	if not sight_component or not manager:
		print("no sight component found")
		return false
	
	var current_pos : Vector2i = entity.map_location
	
	#print(manager.tm_layers["trees"].get_used_cells())
	#print("current pos : " , current_pos , " | sight distance: " , sight_component.sight_distance)
	var tree_locations = manager.get_non_empty_cells_in_radius("trees", current_pos, sight_component.sight_distance)
	var debris_locations = manager.get_non_empty_cells_in_radius("debris", current_pos, sight_component.sight_distance)
	var building_locations = manager.get_non_empty_cells_in_radius("buildings", current_pos, sight_component.sight_distance)
	var valid_ground_locations = manager.get_non_empty_cells_in_radius("ground", current_pos, sight_component.sight_distance)
	
	var invalid_locations = tree_locations
	invalid_locations.append(debris_locations)
	invalid_locations.append(building_locations)
	for location in invalid_locations:
		if not invalid_locations.has(location):
			valid_ground_locations.erase(location)

	valid_ground_locations.erase(current_pos)
	
	if valid_ground_locations.size() > 0:
		sight_component.target_tile = sight_component.get_closest_point(current_pos, valid_ground_locations)
		return true
	print("no valid location found")
	return false
