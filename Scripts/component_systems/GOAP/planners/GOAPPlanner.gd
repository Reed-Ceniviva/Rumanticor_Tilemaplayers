class_name GOAPPlanner
extends Node

func make_plan(entity: Entity) -> void:
	var actions = entity.get_component_by_type("CurrentPlanComponent")
	var plan: Array[GOAPAction] = []
	var current_entity_state = entity  # No simulation yet, just checking
	var goal : Goal = entity.get_component_by_type("GoalComponent").goal

	while not goal.is_satisfied(current_entity_state):
		var best_action: GOAPAction = null
		var lowest_cost := INF

		for action in actions:
			if action.is_applicable(current_entity_state):
				if action.cost < lowest_cost:
					best_action = action
					lowest_cost = action.cost

		if best_action == null:
			print("No valid action to satisfy goal: ", goal.name)
			return

		plan.append(best_action)
		# Apply to real entity in actual execution, but here we simulate
		best_action.apply_effects(current_entity_state)
	entity.get_component_by_type("CurrentPlanComponent").plan = plan
	#return plan

func execute_plan(entity: Entity) -> void:
	var plan = entity.get_component_by_type("CurrentPlanComponent").plan
	if plan.is_empty(): return

	var current_action = plan[0]
	if entity.get_component_by_type("CurrentGoalComponent").goal.is_satisfied(entity):
		plan.pop_front()
	else:
		current_action.apply_effects(entity)
