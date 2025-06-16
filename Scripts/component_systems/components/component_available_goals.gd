extends Component
class_name AvailableGoalsComponent

# Dictionary of Goal -> Priority (float)
@export var goals: Dictionary = {}  # { Goal: float }

func _ready():
	component_name = "AvailableGoalsComponent"
	super._init()
