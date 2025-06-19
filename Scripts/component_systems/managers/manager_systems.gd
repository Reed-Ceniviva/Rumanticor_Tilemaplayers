extends Node
class_name SystemManager

var systems: Array[System] = []

func register_system(system: System) -> void:
	if not systems.has(system):
		systems.append(system)

func _process(delta: float) -> void:
	for system in systems:
		if not system.active:
			continue

		for entity in EntityRegistry._entity_store.values():
			if not entity.active:
				continue
			if _matches_required_components(entity, system.required_components):
				system.process(entity)

func _matches_required_components(entity: Entity, required: Array[String]) -> bool:
	for comp_name in required:
		if not entity.has_component_type(comp_name):
			return false
	return true
