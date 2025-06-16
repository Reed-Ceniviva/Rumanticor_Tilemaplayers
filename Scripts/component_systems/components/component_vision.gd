extends Component
class_name VisionComponent

@export var range: float = 32.0  # vision radius in pixels
var visible_entities: Array[int] = []  # entity_ids of currently seen entities

func _init(init_sight_range : float = range):
	range = init_sight_range
	component_name = "VisionComponent"
	super._init()

func clear_vision():
	visible_entities.clear()

func add_visible_entity(entity_id: int):
	if entity_id not in visible_entities:
		visible_entities.append(entity_id)
