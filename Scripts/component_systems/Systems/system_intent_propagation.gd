extends System
class_name IntentPropagationSystem

var intent_registry = IntentRegistry.new()
var reevaluate_ticker = 0


func process(entity: Entity) -> void:
	if not entity.has_component_type("BrainComponent"):
		print("entity does not have a brain")
		return
	
	var brain = entity.get_component_by_type("BrainComponent")
	var memory = brain.memory

	if not memory.has("goal_intent"):
		print("entity has no goals")
		return
	var current_intent
	if reevaluate_ticker < 10:
		current_intent = memory.get("intent", memory["goal_intent"])
		reevaluate_ticker += 1
	else:
		current_intent = memory.get("goal_intent", memory["life_goals"])
		reevaluate_ticker = 0
		
	var resolved_intent = resolve_intent(entity, current_intent)

	if resolved_intent != current_intent:
		memory["intent"] = resolved_intent
		print("Intent updated:", current_intent, "→", resolved_intent)

func resolve_intent(entity: Entity, intent: String) -> String:
	print("resolving the intent: " , intent)
	var blueprint = intent_registry.get_blueprint(intent)
	if not blueprint:
		print("no blueprint for intent")
		return ""

	# Check preconditions using evaluators
	for precondition in blueprint.get("preconditions", []):
		if not evaluate_precondition(entity, precondition):
			# Try fallback intents recursively
			for fallback in blueprint.get("fallback_intents", []):
				var resolved = resolve_intent(entity, fallback)
				if resolved != "":
					return resolved
			print("unable to resolve intent")
			return ""  # No valid path

	return intent  # Preconditions satisfied

func evaluate_precondition(entity: Entity, precondition: Dictionary) -> bool:
	var comp_type = precondition.get("component", "")
	var method = precondition.get("check", "")
	var args = precondition.get("args", [])

	if not entity.has_component_type(comp_type):
		print("entity does not have needed component: ", comp_type)
		return false

	var comp = entity.get_component_by_type(comp_type)
	if not comp.has_method(method):
		print("component does not have needed method: ", method)
		return false

	# Replace placeholders like "entity" or "target" while preserving order
	var resolved_args: Array = []
	for i in range(args.size()):
		var arg = args[i]
		if typeof(arg) == TYPE_STRING:
			match arg:
				"entity":
					resolved_args.append(entity)
				"target":
					if not comp is BrainComponent:
						var brain = entity.get_component_by_type("BrainComponent")
						resolved_args.append(brain.memory.get("target", -1))
					else:
						resolved_args.append(arg)
				_:
					resolved_args.append(arg)
		else:
			resolved_args.append(arg)
		
	print("calling :", method, " with args: ",resolved_args)
	return comp.callv(method, resolved_args)
