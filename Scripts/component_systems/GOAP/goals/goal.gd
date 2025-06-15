extends Resource
class_name Goal

@export var name: String = "Goal"

func is_satisfied(entity: Entity) -> bool:
	return false  # Override in subclasses
