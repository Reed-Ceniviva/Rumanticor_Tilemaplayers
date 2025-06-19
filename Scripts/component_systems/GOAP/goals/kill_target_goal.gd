extends Goal
class_name KillTargetGoal

func _init():
	name = "KillTarget"

##checks if the entities components show that the goal has been achieved
##
## Takes- entity : Entity = the entity to check the state of. (components and component data) 
## Returns- bool : if the goal has been achieved
func is_satisfied(entity: Entity) -> bool:
	if not entity.has_component_type("TargetEntityComponent"):
		return false
	var target_comp = entity.get_component_by_type("TargetEntityComponent")
	if EntityRegistry._entity_store.has(target_comp.target):
		return false
	else:
		return true
