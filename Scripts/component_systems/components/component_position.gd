extends Component
class_name PositionComponent

var pos : Vector2i = Vector2i(-1,-1)

func _init(init_pos : Vector2i = pos):
	pos = init_pos
	component_name = "PositionComponent"
	super._init()
	

func _get_target_position(target_id: int) -> Vector2i:
	if target_id == -1 or not EntityRegistry._entity_store.has(target_id):
		return  Vector2i.ZERO
	
	var target_entity = EntityRegistry._entity_store[target_id]
	if not target_entity.has_component_type("PositionComponent"):
		return  Vector2i.ZERO
	
	return target_entity.get_component_by_type("PositionComponent").pos

func not_at_target_position(target_id : int) -> bool:
	var target_pos = _get_target_position(target_id)
	if target_pos == null:
		return false
	if pos == target_pos:
		return false
	else:
		return true

func is_in_melee_range_of_target(entity : Entity , target_id: int) -> bool:
	var target_pos = _get_target_position( target_id)
	if target_pos == null:
		return false
	
	var brain = entity.get_component_by_type("BrainComponent")
	var melee_range = brain.memory.get("melee_range", 1.0)
	return pos.distance_to(target_pos) <= melee_range

func is_in_grab_range_of_target( target_id: int) -> bool:
	var target_pos = _get_target_position( target_id)
	if target_pos == null:
		return false
	
	return pos.distance_to(target_pos) <= 1.0
