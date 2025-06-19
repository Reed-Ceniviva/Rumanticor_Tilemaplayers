extends Component
class_name TargetEntityComponent

var target : int

func _init(init_target : int = -1):
	component_name = "TargetEntityComponent"
	if init_target:
		target = init_target
	super._init()
