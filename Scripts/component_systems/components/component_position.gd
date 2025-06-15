extends Component
class_name PositionComponent

var pos : Vector2i = Vector2i(-1,-1)

func _init(init_pos : Vector2i = pos):
	pos = init_pos
	component_name = "PositionComponent"
	super._init()
	
