# component.gd
extends Resource
class_name Component

@export var component_name: String = "Component"

static var _registered := false

func _init():
	if not _registered:
		ComponentRegistry.register_component(component_name, self.get_script())
		_registered = true

func setup(data: Dictionary = {}) -> void:
	var prop_names := []
	for prop in get_property_list():
		prop_names.append(prop.name)

	for key in data.keys():
		if key in prop_names:
			set(key, data[key])
