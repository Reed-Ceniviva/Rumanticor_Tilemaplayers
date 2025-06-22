extends Component
class_name PositionComponent

var pos : Vector2i = Vector2i(-1,-1)

func _init(init_pos : Vector2i = pos):
	pos = init_pos
	component_name = "PositionComponent"
	super._init()
	

func is_in_melee_range_of_target(entity : Entity , target_key: String) -> bool:
	var brain = entity.get_component_by_type("BrainComponent")
	if not brain:
		return false
	
	var melee_range = brain.memory.get("melee_range", 1.0)
	var target_id = brain.memory.get(target_key, null)
	if target_id == null or not EntityRegistry._entity_store.has(target_id):
		return false

	var target_entity = EntityRegistry._entity_store[target_id]
	if not target_entity.has_component_type("PositionComponent"):
		return false

	var target_pos = target_entity.get_component_by_type("PositionComponent").pos
	return pos.distance_to(target_pos) <= melee_range

func is_in_grab_range_of_target(entity : Entity , target_key: String) -> bool:
	var brain = entity.get_component_by_type("BrainComponent")
	if not brain:
		return false
	
	var melee_range = 1.0
	var target_id = brain.memory.get(target_key, null)
	if target_id == null or not EntityRegistry._entity_store.has(target_id):
		return false

	var target_entity = EntityRegistry._entity_store[target_id]
	if not target_entity.has_component_type("PositionComponent"):
		return false

	var target_pos = target_entity.get_component_by_type("PositionComponent").pos
	return pos.distance_to(target_pos) <= melee_range
