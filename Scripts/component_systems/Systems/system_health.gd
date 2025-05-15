extends Node
class_name system_health

func update(worker : Worker):
	if not worker.has_component(component_health):
		return
	
	var health = worker.get_component(component_health)
	
	if health.current_health <= 0:
		print(worker.name, " has died.")
		worker.queue_free()
