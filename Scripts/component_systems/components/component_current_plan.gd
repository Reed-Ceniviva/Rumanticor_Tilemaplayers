extends Component
class_name CurrentPlanComponent

var plan: Array[GOAPAction] = []
var current_action: GOAPAction = null

func _init():
	component_name = "CurrentPlanComponent"
	super._init()

func has_plan() -> bool:
	return plan.size() > 0 or current_action != null

func start_next_action() -> void:
	if plan.size() > 0:
		current_action = plan.pop_front()
	else:
		current_action = null

func peek_next_action() -> GOAPAction:
	return plan[0] if plan.size() > 0 else null

func clear_plan() -> void:
	plan.clear()
	current_action = null

func is_action_in_progress() -> bool:
	return current_action != null
