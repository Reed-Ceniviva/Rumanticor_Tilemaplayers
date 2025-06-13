extends Node
class_name Entity

var components: Dictionary = {}  # Keyed by component class_name
var entity_id: int = -1

func add_component(component: Component) -> void:
	components[component.component_name] = component

func get_component(component_name: String) -> Component:
	return components.get(component_name)

func has_component(component_name: String) -> bool:
	return components.has(component_name)

func remove_component(component_name: String) -> void:
	components.erase(component_name)
