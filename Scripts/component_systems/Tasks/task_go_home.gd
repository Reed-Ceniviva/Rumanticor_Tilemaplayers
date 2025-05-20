extends task
class_name task_go_home

var movement_system: system_movement

func setup(_movement_system : system_movement):
	task_type = "go_home"
	movement_system = _movement_system

func execute(entity) -> bool:
	print("attempting to go home")
	if not entity.has_meta("component_movement"):
		print("trying to move with no movement component")
		return false
		
	if not entity.has_meta("component_family"):
		print("no family component for task_go_home")
		return false
	
	var family_component = entity.get_meta("component_family")
	var home = family_component.home
	
	# Make sure the target is valid
	if home == Vector2i(-1, -1):
		print("invalid home for task_go_home")
		return false
	
	if home == entity.map_location:
		return true
	
	# Try to move to the target tile
	var success = movement_system.move_to(entity, home)
	return success
