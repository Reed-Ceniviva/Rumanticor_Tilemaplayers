extends Component
class_name ActionQueueComponent

var action_queue: Array[GOAPAction] = []
var current_action: GOAPAction = null

func _ready():
	component_name = "ActionQueueComponent"
	super._init()

func enqueue_action(action: GOAPAction) -> void:
	action_queue.append(action)

func dequeue_action() -> GOAPAction:
	if action_queue.is_empty():
		return null
	return action_queue.pop_front()
