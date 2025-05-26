class_name EntityBase
extends Node2D  # Or use Resource if you're not instancing into the scene

var components: Dictionary = {}
var entity_id : int

func _ready():
	var wm = find_parent("World Manager")
	if wm:
		entity_id = wm.new_entity_id(self)
	else:
		push_error("EntityBase could not find World Manager to assign entity_id")

func add_component(component: Component):
	var name = component.get_comp_name()
	if name == "Component":
		push_error("Component missing component name assignment, is set as Component")
		return
	components[name] = component

func get_component(component_class_name: String) -> Resource:
	if components.has(component_class_name):
		return components.get(component_class_name, null)
	else:
		push_error("Component '%s' not found in entity %s" % [component_class_name, str(entity_id)])

		return null

func has_component(type_name: String) -> bool:
	return components.has(type_name)

func remove_component(type_name: String):
	if components.has(type_name):
		components.erase(type_name)
	else:
		push_warning("Tried to remove nonexistent component: %s" % type_name)
