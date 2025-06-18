extends Goal
class_name TargetItemEquippedGoal

func _ready():
	name = "TargetItemEquipped"

##checks if the entities components show that the goal has been achieved
##
## Takes- entity : Entity = the entity to check the state of. (components and component data) 
## Returns- bool : if the goal has been achieved
func is_satisfied(entity: Entity) -> bool:
	if not entity.has_component_type("TargetEntityComponent"):
		return false
	if not entity.has_component_type("EquipmentComponent"):
		return false

	var target_id = entity.get_component_by_type("TargetEntityComponent").target
	var equi_comp : EquipmentComponent = entity.get_component_by_type("EquipmentComponent")
	for part in equi_comp.equippable_body.keys:
		for equi in equi_comp.equippable_body[part]:
			if equi.entity_id == target_id:
				return true
	return false
