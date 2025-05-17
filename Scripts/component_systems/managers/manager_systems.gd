# system_manager.gd
extends Node
class_name manager_system

#var system_movement_instance: system_movement

func _ready():
	#system_movement_instance = system_movement.new()
	#system_movement_instance.world_layer_manager = get_node("/root/WorldLayerManager")
	#system_movement_instance.astar_grid = get_node("/root/WorldCharacterManager").astar_grid
	#add_child(system_movement_instance)
	pass

func _process(delta: float):
	for entity in get_tree().get_nodes_in_group("ecs_entities"):
		#system_movement_instance.process_entity(entity, delta)
		pass
