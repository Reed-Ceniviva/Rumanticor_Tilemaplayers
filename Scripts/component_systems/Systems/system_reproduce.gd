extends Node

func reproduce(worker : Worker, world_layer_manager):
	var family = worker.get_component(FamilyComponent)
	var stats = worker.get_component(component_charstats)
	var timers = worker.get_component(component_lifetimers)

	var new_worker = preload("res://Scenes/Characters/ECS/Entities/entity_worker.tscn").new()
	new_worker.position = world_layer_manager.tm_layers["ground"].map_to_local(worker.get_component(component_movement).destination + Vector2i(1,0))
	worker.get_parent().add_child(new_worker)
	family.offspring.append(new_worker)
	timers.birth_delay = randi() % (18 - 2) + 2
