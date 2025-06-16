extends Goal
class_name LocateSaughtGoal

func _ready():
	name = "LocateSaught"

##checks if the entities components show that the goal has been achieved
##
## Takes- entity : Entity = the entity to check the state of. (components and component data) 
## Returns- bool : if the goal has been achieved
func is_satisfied(entity: Entity) -> bool:
	if not entity.has_component_type("TargetEntityComponent"):
		return false
	if not entity.has_component_type("SaughtEntityComponent"):
		return false

	var target_id = entity.get_component_by_type("TargetEntityComponent").target
	if EntityRegistry._entity_store.has(target_id):
		var saught_ent : Entity = entity.get_component_by_type("SaughtEntityComponent").saught
		if EntityRegistry._entity_store[target_id].is_class(saught_ent.get_class()):
			return true
		else:
			return false
	else:
		return false
