extends Resource
class_name GOAPAction

@export var name: String
@export var cost: float = 100.0

##checks if an entity has the needed components to take this action
func is_applicable(entity: Entity) -> bool:
	return true  # Override

func apply_effects(entity: Entity) -> void:
	pass  # Override
