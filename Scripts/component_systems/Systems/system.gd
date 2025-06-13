extends Node
class_name System

# System processes a specific set of components
var required_components: Array[String] = []

func _process_entities(entities: Array[Entity]) -> void:
	for entity in entities:
		if _matches(entity):
			process(entity)

func _matches(entity: Entity) -> bool:
	for comp_name in required_components:
		if not entity.has_component(comp_name):
			return false
	return true

# Override this in derived systems
func process(entity: Entity) -> void:
	pass
