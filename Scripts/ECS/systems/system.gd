# res://ecs/system.gd
extends Node
class_name System

# List of entities this system processes
var entities: Array = []

# Optional name of component this system operates on
@export var required_component_name: String = ""

# Add entity to be managed
func add_entity(entity: Entity) -> void:
	if not entities.has(entity):
		entities.append(entity)

# Remove entity from system
func remove_entity(entity: Entity) -> void:
	entities.erase(entity)

# Main update function called every frame or tick
func process_system(delta: float) -> void:
	for entity in entities:
		if required_component_name == "" or entity.has_component(required_component_name):
			process_entity(entity, delta)

# Override this in subclasses
func process_entity(entity: Entity, delta: float) -> void:
	pass
