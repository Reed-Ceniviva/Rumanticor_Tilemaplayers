extends Goal
class_name BecomeHousedGoal

func _ready():
	name = "BecomeHoused"

##checks if the entities components show that the goal has been achieved
##
## Takes- entity : Entity = the entity to check the state of. (components and component data) 
## Returns- bool : if the goal has been achieved
func is_satisfied(entity: Entity) -> bool:
	if not entity.has_component_type("HousedComponent"):
		return false

	var housed_comp : HousedComponent = entity.get_component_by_type("HousedComponent")
	if not housed_comp.is_housed:
		return false

	return true
