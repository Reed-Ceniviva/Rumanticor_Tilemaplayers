class_name GOAPPlanner
extends Node

func make_plan(entity: Entity) -> void:
	if not entity:
		return
	var action_comp = entity.get_component_by_type("AvailableActionsComponent")
	var available_actions : Array[GOAPAction] = []
	if action_comp:
		available_actions = action_comp.actions
	var plan: Array[GOAPAction] = []
	var current_entity_state = entity  # No simulation yet, just checking
	var goal : Goal = entity.get_component_by_type("CurrentGoalComponent").goal

	if available_actions.is_empty():
		available_actions = ActionRegistry.get_applicable_actions(entity)

	var max_iterations := 20
	var iteration_count := 0

	if not goal.is_satisfied(current_entity_state):
		var best_action: GOAPAction = null
		var lowest_cost := INF

		for action in available_actions:
			if action.is_applicable(current_entity_state):
				if action.cost < lowest_cost:
					best_action = action
					lowest_cost = action.cost

		if best_action == null:
			print("No valid action to satisfy goal: ", goal.name)

		plan.append(best_action)
		
	if plan.is_empty():
		print("Plan creation failed for goal: ", goal.name)
	else:
		entity.get_component_by_type("CurrentPlanComponent").plan = plan

		# If simulating effects, you'd want a simulation state here
		# best_action.apply_effects(current_entity_state)


func execute_plan(entity: Entity) -> void:
	var plan_comp = entity.get_component_by_type("CurrentPlanComponent")
	if not plan_comp.is_action_in_progress():
		plan_comp.start_next_action()

	if plan_comp.current_action != null:
		var action = plan_comp.current_action
		if action.is_applicable(entity):
			action.apply_effects(entity)
			plan_comp.start_next_action()
		else:
			plan_comp.clear_plan()  # Plan is no longer valid
