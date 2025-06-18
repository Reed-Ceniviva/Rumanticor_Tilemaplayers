extends System
class_name GoalGeneratorSystem

func generate_available_goals(entity: Entity) -> Array[Goal]:
	var goals: Array[Goal] = []

	for component_name in entity.get_all_component_types():
		if AffordanceRegistry.affordances.has(component_name):
			var goal_factory = AffordanceRegistry.affordances[component_name]
			goals += goal_factory.call(entity)  # Add all goals for this component

	return goals
