# system_movement.gd
extends Node
class_name system_movement

# set when the movement system is initially created in character manager
var world_layer_manager
var astar_grid 


func process_entity(entity: entity_worker, delta: float) -> void:
	if not entity.has_meta("component_movement"):
		return
	
	var movement = entity.get_meta("component_movement")
	
	if movement.current_id_path.size() > 0:
		#print("entity moved")
		entity._animated_sprite_2d.play("default")
		var next_tile = movement.current_id_path.pop_front()
		var next_location = world_layer_manager.tm_layers["ground"].map_to_local(next_tile)
		entity.map_location = next_tile
		entity.position = next_location
		

func move_to(entity: Node2D, target_pos: Vector2i, enter: bool = false) -> bool:
	var movement = entity.get_meta("component_movement")
	if movement == null:
		print("entity has null movement component")
		return false
	
	movement.current_id_path.clear()
	
	var ground_layer = world_layer_manager.tm_layers.get("ground", null)
	if ground_layer == null:
		print("null ground layer")
		return false
	
	var start_pos = ground_layer.local_to_map(entity.position)
	var id_path : Array[Vector2i] = astar_grid.get_id_path(start_pos, target_pos).slice(1)
	
	if not enter and id_path.size() > 0:
		id_path = id_path.slice(0, id_path.size() - 1)
	
	if id_path.size() >= 0:
		movement.current_id_path = id_path
		if entity.has_meta("component_sight"):
			entity.get_meta("component_sight").target_tile = target_pos
		return true
	print("no path to target or pathing to current position")
	return false
