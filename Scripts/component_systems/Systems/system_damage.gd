extends System
class_name DamageSystem

func process(entity: Entity) -> void:
	##remove equipment requirement, just make it a sub check
	if not entity.has_component_type("SphereStatsComponent") or not entity.has_component_type("EquipmentComponent"):
		return

	var brain: BrainComponent = entity.get_component_by_type("BrainComponent")
	var equip: EquipmentComponent = entity.get_component_by_type("EquipmentComponent")

	# Fetch strength stat from brain's sphere_stats
	var strength := 1.0  # Default fallback
	if brain.memory.has("sphere_stats") and brain.memory["sphere_stats"].has("strength"):
		strength = brain.memory["sphere_stats"]["strength"]

	var weapon_damage := 0.0
	var weapon: Entity = equip.get_strongest_equipped_weapon()
	if weapon and weapon.has_component_type("EquippableComponent"):
		weapon_damage = weapon.get_component_by_type("EquippableComponent").damage_mod

	if weapon_damage == 0.0:
		weapon_damage = 1.0  # Unarmed default multiplier

	var total_damage := strength * weapon_damage
	brain.memory["melee_damage"] = total_damage

	print("Entity", entity.name, "→ strength:", strength, ", weapon_mod:", weapon_damage, ", total damage:", total_damage)
