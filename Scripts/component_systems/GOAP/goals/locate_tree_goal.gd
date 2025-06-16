extends Goal
class_name LocateTreeGoal


func _ready():
	name = "LocateTree"

##checks if the entities components show that the goal has been achieved
##
## Takes- entity : Entity = the entity to check the state of. (components and component data) 
## Returns- bool : if the goal has been achieved
func is_satisfied(entity: Entity) -> bool:
	if not entity.has_component_type("TargetEntityComponent"):
		return false

	var target_id = entity.get_component_by_type("TargetEntityComponent").target
	if not EntityRegistry._entity_store.has(target_id):
		return false

	return EntityRegistry._entity_store[target_id] is TreeEntity
