extends Component
class_name HousedComponent

var home_pos : Vector2i = Vector2i(-1,-1)
var is_housed : bool = false

func _ready():
	component_name = "HousedComponent"
	super._init()
