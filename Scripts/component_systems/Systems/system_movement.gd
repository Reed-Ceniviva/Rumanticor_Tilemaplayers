extends Node

class_name system_movement

func update(worker : Worker, delta, world_layer_manager, astar_grid):
	var move = worker.get_component(component_movement)
	var timers = worker.get_component(component_lifetimers)
	var stats = worker.get_component(component_charstats)

	if stats.health <= 0:
		return

	timers.time += delta
	stats.age = timers.time

	if timers.time > timers.next_move:
		timers.next_move = timers.time + timers.movedelay
		
		if move.current_path.size() > 0:
			worker.position = world_layer_manager.tm_layers["ground"].map_to_local(move.current_path.front())
			move.current_path = move.current_path.slice(1)
