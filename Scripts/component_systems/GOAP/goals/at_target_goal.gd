extends Goal
class_name AtTargetGoal

func _init():
	name = "AtTargetGoal"

##checks if the entities components show that the goal has been achieved
##
## Takes- entity : Entity = the entity to check the state of. (components and component data) 
## Returns- bool : if the goal has been achieved
func is_satisfied(entity: Entity) -> bool:
	if not entity.has_component_type("TargetEntityComponent"):
		return false
	if not entity.has_component_type("PositionComponent"):
		return false
	
	var target_ent_pos = EntityRegistry._entity_store[entity.get_component_by_type("TargetEntityComponent").target].get_component_by_type("PositionComponent").pos
	var ent_pos = entity.get_component_by_type("PositionComponent").pos
	
	if ent_pos == target_ent_pos:
		return true
	else:
		return false
