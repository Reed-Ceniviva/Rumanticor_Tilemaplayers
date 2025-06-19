extends GOAPAction
class_name AttackTargetWithEquippedAction

func _ready():
	name = "AttackTargetWithEquipped"
	cost = 1


##checks if an entity has the needed components to take this action
##
##checks if the prerequisites for the action have been met
## takes entity : Entity = the entity to check if the prerequisites have been met
func is_applicable(entity: Entity) -> bool:
	if not entity.has_component_type("TargetEntityComponent"):
		return false
	var target_ent_id = entity.get_component_by_type("TargetEntityComponent").target
	if not entity.has_component_type("PositionComponent"):
		return false
		
	if not entity.has_component_type("EquipmentComponent"):
		return false
	var equi_comp : EquipmentComponent = entity.get_component_by_type("EquipmentComponent")
	if !equi_comp.non_accessory_equipped("hand"):
		return false
	
	if not entity.has_component_type("SphereStatsComponent"):
		return false
	
	var target_ent = EntityRegistry._entity_store[target_ent_id]
	
	if not target_ent.has_component_type("PositionComponent"):
		return false
		
	if not target_ent.has_component_type("HealthComponent"):
		return false
	
	var target_pos = target_ent.get_component_by_type("PositionComponent").pos
	var my_pos = entity.get_component_by_type("PositionComponent").pos
	var distance_between = my_pos.distance_to(target_pos)
	var equipped_weapon = equi_comp.get_weapon_equipped("hand")
	var equipment_range = 1
	if equipped_weapon:
		equipment_range = equi_comp.get_weapon_equipped("hand").get_component_by_type("EqippableComponent").range
	
	if distance_between > equipment_range:
		print("out of range of euqipped")
		return false
	
	return true
			

##the action of the Gaction
##
## takes entity : Entity = the entity to change data of or change world variables in relation to
## returns void
func apply_effects(entity: Entity) -> void:
	var target_ent_id = entity.get_component_by_type("TargetEntityComponent").target
	var target_ent = EntityRegistry._entity_store[target_ent_id] 
	var ent_spheres_comp = entity.get_component_by_type("SphereStatsComponent")
	var ent_strength = ent_spheres_comp.stats["Strength"]
	var equi_comp : EquipmentComponent = entity.get_component_by_type("EquipmentComponent")
	var damage = equi_comp.get_weapon_equipped("hand").get_component_by_type("EqippableComponent").damage_mod
	var target_ent_health : HealthComponent = target_ent.get_component_by_type("HealthComponent")
	target_ent_health.take_damage(damage*ent_strength)
	ent_strength += 0.01
