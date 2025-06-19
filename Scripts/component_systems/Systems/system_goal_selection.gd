extends System
class_name GoalSelectionSystem

func _init():
	required_components = ["CurrentGoalComponent","AvailableGoalsComponent"]


func process_entity(entity: Entity) -> void:
	if not entity.has_component_type("CurrentGoalComponent"):
		return
	if not entity.has_component_type("AvailableGoalsComponent"):
		return

	var goal_comp = entity.get_component_by_type("CurrentGoalComponent")
	var available_goals = entity.get_component_by_type("AvailableGoalsComponent").goals

	var best_goal: Goal = null
	var best_priority := -INF

	for goal in available_goals.keys():
		var priority = available_goals[goal]
		if not goal.is_satisfied(entity) and priority > best_priority:
			best_goal = goal
			best_priority = priority

	# Only switch goal if different or current is satisfied
	if best_goal != null and (goal_comp.current_goal == null or goal_comp.current_goal.is_satisfied(entity)):
		goal_comp.current_goal = best_goal.duplicate()
