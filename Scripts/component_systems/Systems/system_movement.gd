# system_movement.gd
extends Node
class_name system_movement

var world_layer_manager
var astar_grid

func process_entity(entity: Node2D, delta: float) -> void:
	if not entity.has_meta("component_movement"):
		return
	
	var movement = entity.get_meta("component_movement")
	if movement == null:
		return
	
	movement.next_move_time -= delta
	if movement.next_move_time > 0:
		return
	
	movement.next_move_time = movement.move_delay
	
	if movement.current_id_path.size() > 0:
		#print("entity moved")
		var next_tile = movement.current_id_path.pop_front()
		entity.position = world_layer_manager.tm_layers["ground"].map_to_local(next_tile)

func move_to(entity: Node2D, target_pos: Vector2i, enter: bool = false) -> bool:
	if not entity.has_meta("component_movement"):
		return false
	
	var movement = entity.get_meta("component_movement")
	if movement == null:
		return false
	
	movement.current_id_path.clear()
	
	var ground_layer = world_layer_manager.tm_layers.get("ground", null)
	if ground_layer == null:
		return false
	
	var start_pos = ground_layer.local_to_map(entity.position)
	var id_path : Array[Vector2i] = astar_grid.get_id_path(start_pos, target_pos).slice(1)
	
	if not enter and id_path.size() > 0:
		id_path = id_path.slice(0, id_path.size() - 1)
	
	if id_path.size() > 0:
		movement.current_id_path = id_path
		if entity.has_meta("component_sight"):
			entity.get_meta("component_sight").target_tile = target_pos
		return true
	
	return false
