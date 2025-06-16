extends Component
class_name AvailableActionsComponent

@export var actions: Array[GOAPAction] = []

# full type : Dictionary[String, Array[GOAPAction]]
var action_categories: Dictionary[String, Array] = {
	"combat": [],
	"gathering": [],
	"movement": []
}

func _ready():
	component_name = "AvailableActionsComponent"
	super._init()
