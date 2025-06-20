extends GOAPAction
class_name EquipTargetItemAction

func _init():
	name = "EquipTargetItem"
	cost = 1.0

##checks if an entity has the needed components to take this action
##
##checks if the prerequisites for the action have been met
## takes entity : Entity = the entity to check if the prerequisites have been met
func is_applicable(entity: Entity) -> bool:
	if not entity.has_component_type("VisionComponent"):
		print("entity does not have vision component")
		return false
	if not entity.has_component_type("TargetEntityComponent") or entity.get_component_by_type("TargetEntityComponent").target == -1:
		print("entity does not have target component")
		return false
	if not EntityRegistry._entity_store[entity.get_component_by_type("TargetEntityComponent").target].has_component_type("EquippableComponent"):
		print("target entity is not equipplable")
		return false
	if not entity.has_component_type("EquipmentComponent"):
		print("entity does not have equipment component to equip to")
		return false
	var can_equip : bool = false
	var equi_comp = entity.get_component_by_type("EquipmentComponent")
	var target_id = entity.get_component_by_type("TargetEntityComponent").target
	for body_part in equi_comp.equippable_body.keys():
		if body_part.contains(EntityRegistry._entity_store[target_id].get_component_by_type("EquippableComponent").equips_to):
			print("equippable body part slot found")
			can_equip = true
			break
	
	var target_ent : Entity = EntityRegistry._entity_store[target_id]
	var in_range = false
	if target_ent.get_component_by_type("PositionComponent").pos.distance_to(entity.get_component_by_type("PositionComponent").pos) <= 2:
		print("in range to use equipped item")
		in_range = true
	
	if can_equip and in_range:
		return true  # Override
	else:
		print("item not in range or unable to equip item")
		return false

##the action of the Gaction
##
## takes entity : Entity = the entity to change data of or change world variables in relation to
## returns void
func apply_effects(entity: Entity) -> void:
	var equi_comp : EquipmentComponent = entity.get_component_by_type("EquipmentComponent")
	var target_id = entity.get_component_by_type("TargetEntityComponent").target
	equi_comp.equip_entity(EntityRegistry._entity_store[target_id])
	entity.get_component_by_type("TargetEntityComponent").target = -1
