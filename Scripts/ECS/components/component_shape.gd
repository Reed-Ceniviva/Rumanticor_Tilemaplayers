extends Component
class_name ComponentShape

var shape_type: int
var shape_args: Dictionary

func _init():
	comp_name = "shape"

func get_volume_args() -> Dictionary:
	return shape_args
