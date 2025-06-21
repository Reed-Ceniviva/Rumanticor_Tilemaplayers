extends System
class_name IntentPropagationSystem

func process(entity: Entity) -> void:
	if not entity.has_component_type("BrainComponent"):
		return
	
	var brain = entity.get_component_by_type("BrainComponent")
	var memory = brain.memory

	if not memory.has("goal_intent"):
		return
	
	var current_intent = memory.get("intent", memory["goal_intent"])
	var resolved_intent = resolve_intent(entity, current_intent)

	if resolved_intent != current_intent:
		memory["intent"] = resolved_intent
		print("Intent updated:", current_intent, "→", resolved_intent)

func resolve_intent(entity: Entity, intent: String) -> String:
	var blueprint = IntentRegistry.get_blueprint(intent)
	if not blueprint:
		return ""

	# Check preconditions using evaluators
	for precondition in blueprint.get("preconditions", []):
		if not evaluate_precondition(entity, precondition):
			# Try fallback intents recursively
			for fallback in blueprint.get("fallback_intents", []):
				var resolved = resolve_intent(entity, fallback)
				if resolved != "":
					return resolved
			return ""  # No valid path

	return intent  # Preconditions satisfied

func evaluate_precondition(entity: Entity, precondition: Dictionary) -> bool:
	var comp_type = precondition.get("component", "")
	var method = precondition.get("check", "")
	var args = precondition.get("args", [])

	if not entity.has_component_type(comp_type):
		return false

	var comp = entity.get_component_by_type(comp_type)
	if not comp.has_method(method):
		return false

	return comp.callv(method, args)
