extends GOAPAction
class_name FindSaughtEntityInSight

func _ready():
	name = "FindSaughtEntityInSight"
	cost = 1


##checks if an entity has the needed components to take this action
##
##checks if the prerequisites for the action have been met
## takes entity : Entity = the entity to check if the prerequisites have been met
func is_applicable(entity: Entity) -> bool:
	if not entity.has_component_type("VisionComponent"):
		return false
	if not entity.has_component_type("TargetEntityComponent"):
		return false
	if not entity.has_component_type("SaughtEntityComponent"):
		return false
	return true  # Override

##the action of the Gaction
##
## takes entity : Entity = the entity to change data of or change world variables in relation to
## returns void
func apply_effects(entity: Entity) -> void:
	var sight = entity.get_component_by_type("VisionComponent").visible_entities
	var saught = entity.get_component_by_type("SaughtEntityComponent").saught
	var found = false
	for entity_id in sight:
		if EntityRegistry._entity_store[entity_id].is_class(saught.get_class()):
			entity.get_component_by_type("TargetEntityComponent").target = entity_id
			found = true
			break
	if not found:
		entity.get_component_by_type("TargetEntityComponent").target = null
