extends Node

func chop_tree(worker : entity_worker, world_layer_manager):
	var move = worker.get_component(component_movement)
	var inv = worker.get_component(component_inventory)
	var perception = worker.get_component(component_sight)
	
	var surroundings = world_layer_manager.get_non_empty_cells_in_radius("trees", worker.get_component(component_movement).destination, 1)
	if surroundings.size() > 0:
		world_layer_manager.tree_chopped(surroundings[0])
		inv.items["wood"] += 1
		return true
	else:
		return false
