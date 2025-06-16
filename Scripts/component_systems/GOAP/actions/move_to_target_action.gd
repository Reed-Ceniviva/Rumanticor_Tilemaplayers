extends GOAPAction
class_name MoveToTargetAction

func _ready():
	name = "MoveToTarget"
	cost = 32
	
##checks if an entity has the needed components to take this action
##
##checks if the prerequisites for the action have been met
## takes entity : Entity = the entity to check if the prerequisites have been met
func is_applicable(entity: Entity) -> bool:
	if not entity.has_component_type("MobilityComponent"):
		return false
	if not entity.has_component_type("TargetEntityComponent"):
		return false
	if not entity.has_component_type("MovementPathComponent"):
		return false
	return true  # Override

##the action of the Gaction
##
## takes entity : Entity = the entity to change data of or change world variables in relation to
## returns void
func apply_effects(entity: Entity) -> void:
	# No intent flag, but we ensure that the TargetEntityComponent is set.
	# This indirectly enables the NavigationSystem to act on it.
	pass
	
	
