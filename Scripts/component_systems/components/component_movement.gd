extends Resource
class_name component_movement

var current_id_path: Array[Vector2i] = []
@export var move_delay: float = 0.25
var next_move_time: float = 0.0

## Manually sets the movement speed
func setup(move_speed: float = 1.0):
	move_delay = move_speed
