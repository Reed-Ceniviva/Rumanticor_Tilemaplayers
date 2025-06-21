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

func type_in_sight(entity : Entity) -> bool:
	for ent_id in visible_entities:
		if EntityRegistry._entity_store[ent_id].get_class() == entity.get_class():
			return true
	return false
	
func type_in_range(entity : Entity, range : float = 1.0):
	if not type_in_range(entity):
		return false
	for ent_id in visible_entities:
		var ent = EntityRegistry._entity_store[ent_id]
		if ent.get_class() == entity.get_class():
			var ent_pos = ent.get_component_by_type("PositionComponent").pos
			if entity.get_component_by_type("PositionComponent").pos.distance_to(ent_pos) <= range:
				return true
			else:
				return false
