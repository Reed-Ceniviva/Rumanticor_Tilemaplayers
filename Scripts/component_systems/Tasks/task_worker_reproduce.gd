extends task
class_name task_worker_reproduce

const ENTITY_WORKER = preload("res://Scenes/Characters/ECS/Entities/entity_worker.tscn")

func execute(entity : entity_worker) -> bool:
	var new_worker = ENTITY_WORKER.instantiate()
	new_worker.setup(entity.my_layer_manager)
	new_worker.position = entity.map_location + Vector2i.RIGHT
	var family : component_family = entity.get_meta("component_family")
	family.offspring.append(new_worker)
	entity.get_parent().add_child(new_worker)
	return true
