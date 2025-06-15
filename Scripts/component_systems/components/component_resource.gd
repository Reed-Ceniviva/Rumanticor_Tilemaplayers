extends Component
class_name ComponentResource

var type : String = "wood"

func _init(init_type : String = type):
	type = init_type
	component_name = "ResourceComponent"
	super._init()
