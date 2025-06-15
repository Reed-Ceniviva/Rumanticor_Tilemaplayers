extends Node
class_name System

var required_components: Array[String] = []
var required_tags: Array[String] = []  # New
var active: bool = true

func process(entity: Entity) -> void:
	pass

func set_active(state: bool) -> void:
	active = state
