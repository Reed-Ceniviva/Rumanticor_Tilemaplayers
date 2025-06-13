# component.gd
extends Resource
class_name Component

@export var comp_name: String = "Component"

func setup(data: Dictionary = {}) -> void:
	var prop_names := []
	for prop in get_property_list():
		prop_names.append(prop.name)

	for key in data.keys():
		if key in prop_names:
			set(key, data[key])
