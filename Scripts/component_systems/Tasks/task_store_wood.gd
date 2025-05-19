extends task
class_name task_store_wood

func execute(entity) -> bool:
	print("attempting locate adjacent building")
	var sight_component : component_sight = entity.get_meta("component_sight")
	var manager : layer_manager = entity.my_layer_manager
	if not sight_component or not manager:
		print("no sight component found")
		return false
	
	var current_pos : Vector2i = entity.map_location
	
	#print(manager.tm_layers["trees"].get_used_cells())
	#print("current pos : " , current_pos , " | sight distance: " , sight_component.sight_distance)
	var buildings = manager.get_non_empty_cells_in_radius("buildings", current_pos, 1)
	var home_location : Vector2i = entity.get_meta("component_family").home
	var entity_inventory : component_inventory = entity.get_meta("component_inventory")
	print(buildings)
	buildings.erase(current_pos)
	
	if buildings.has(home_location):
		var home_info = manager.building_data.get_cell_data(home_location)
		home_info.get_or_add("wood")
		if entity_inventory.has_item("wood"):
			home_info.set("wood", entity_inventory.get_item_count("wood"))
			entity_inventory.remove_item("wood", entity_inventory.get_item_count("wood"))
			return true
		else:
			print("no wood to store in the house")
	return false
