extends System
class_name GoalSelectionSystem

@export var available_goals: Array[Goal] = []

func process_entity(entity: Entity, delta: float) -> void:
	if not entity.has_component_type("CurrentGoalComponent"): return
	
	var goal_comp = entity.get_component_by_type("CurrentGoalComponent")
	var current_goal = goal_comp.current_goal
	
	if current_goal == null or current_goal.is_satisfied(entity):
		# Pick a new goal (you can add scoring logic here)
		for goal in available_goals:
			if not goal.is_satisfied(entity):
				goal_comp.current_goal = goal.duplicate()
				break
