extends System
class_name GOAPPlannerSystem

@export var available_actions: Array[GOAPAction] = []

func process_entity(entity: Entity, delta: float) -> void:
	if not entity.has_component("GoalComponent") or not entity.has_component("ActionQueueComponent"):
		return

	var goal = entity.get_component("GoalComponent").current_goal
	if goal.is_satisfied(entity):
		return  # Already done

	var queue = entity.get_component("ActionQueueComponent")
	if not queue.action_queue.is_empty():
		return  # Already planned

	# Simple greedy planner: pick one applicable action that brings us closer
	for action in available_actions:
		if action.is_applicable(entity):
			queue.enqueue_action(action)
			break
