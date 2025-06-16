extends Component
class_name MovementPathComponent

var current_path: Array[Vector2i] = []
var current_step_index := 0

func has_next_step() -> bool:
	return current_step_index < current_path.size()

func get_next_position() -> Vector2i:
	return current_path[current_step_index] if has_next_step() else Vector2i(-1, -1)

func advance_step() -> void:
	if has_next_step():
		current_step_index += 1

func reset_path() -> void:
	current_path.clear()
	current_step_index = 0

func is_complete() -> bool:
	return current_step_index >= current_path.size()

func _ready():
	component_name = "MovementPathComponent"
	super._init()
