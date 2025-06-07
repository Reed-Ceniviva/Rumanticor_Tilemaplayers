# res://ecs/entity.gd
extends Node
class_name Entity

@onready var wm : world_manager = $"../../.."
var entity_id : int = 0
# Components stored using comp_name as key
var components: Dictionary = {}
var idd = false

func _init():
	pass
	#wm.new_entity_id(self)
# Add a component

func _process(delta):
	if wm and !idd:
		wm.new_entity_id(self)
		idd = true 
	

func add_component(component: Component) -> void:
	var name: String = component.get_comp_name()
	if components.has(name):
		push_warning("Component '%s' already exists on entity '%s'." % [name, name])
		return
	components[name] = component

# Get a component by name
func get_component(name: String) -> Component:
	return components.get(name, null)

# Check if a component exists
func has_component(name: String) -> bool:
	return components.has(name)

# Remove a component
func remove_component(name: String) -> void:
	if components.has(name):
		components.erase(name)

# Clear all components (e.g. when entity dies or resets)
func clear_components() -> void:
	components.clear()

func set_world_manager(_wm : world_manager):
	wm = _wm
