extends Node2D
class_name Worker

var components : Dictionary = {}

func add_component(component):
	components[component.get_class()] = component

func get_component(component_class):
	return components.get(component_class, null)

func has_component(component_class):
	return components.has(component_class)
