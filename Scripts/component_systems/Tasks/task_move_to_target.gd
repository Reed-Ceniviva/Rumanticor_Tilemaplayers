extends task
class_name task_move_to_target

var movement_system: system_movement

func setup(_movement_system : system_movement):
	task_type = "move_to_target"
	movement_system = _movement_system

func execute(entity) -> bool:
	print("attempting to move")
	if not entity.has_meta("component_movement"):
		print("trying to move with no movement component")
		return false
		
	if not entity.has_meta("component_sight"):
		print("no sight component for task_move_to_target")
		return false
	
	var sight_component = entity.get_meta("component_sight")
	var target = sight_component.target_tile
	
	# Make sure the target is valid
	if target == Vector2i(-1, -1):
		print("invalid target for task_move_to_target")
		return false
	
	if target == entity.map_location:
		return true
	
	# Try to move to the target tile
	var success = movement_system.move_to(entity, target)
	return success
