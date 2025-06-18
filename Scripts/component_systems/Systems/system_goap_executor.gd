extends System
class_name GOAPExecutorSystem

func process_entity(entity: Entity) -> void:
	if not entity.has_component("ActionQueueComponent"):
		return

	var queue = entity.get_component("ActionQueueComponent")

	if queue.current_action == null:
		queue.current_action = queue.dequeue_action()
		if queue.current_action == null:
			return

	# Assume instant actions for now
	queue.current_action.apply_effects(entity)
	queue.current_action = null
