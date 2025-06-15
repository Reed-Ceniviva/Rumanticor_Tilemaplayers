extends Component
class_name EquipmentComponent

var equippable_body : Dictionary[String,Array] = {
	"back":[],
	"hand,left":[],
	"hand,right":[]
	}

func _init(init_body_equipment: Dictionary = {}):
	super._init()
	component_name = "EquipmentComponent"
	
	# Use default if empty
	if init_body_equipment.is_empty():
		equippable_body = {
			"back": [],
			"hand,left": [],
			"hand,right": []
		}
	else:
		equippable_body = init_body_equipment

func equip_entity(entity : Entity) -> bool:
	if entity.has_component_type("EquippableComponent"):
		var equippable_comp : EquippableComponent= entity.get_component_by_type("EquippableComponent")
		var equi_comp_equip_to = equippable_comp.equips_to
		for key in equippable_body.keys():
			if equi_comp_equip_to in key:
				var body_part_equipment : Array[Entity] = equippable_body.get(key)
				for equipment in body_part_equipment:
					if equipment.has_component_type("EquippableComponent"):
						var equipped_equi_comp : EquippableComponent = equipment.get_component_by_type("EquippableComponent")
						if not equipped_equi_comp.accessory:
							return false
				equippable_body[key].append(entity)
				entity.set_active(false)
				return true
		return false
	else:
		# the entity you are trying to equip is not equippable
		return false

func remove_equipment(entity : Entity) -> Entity:
	for part in equippable_body:
		if entity in equippable_body[part]:
			equippable_body[part].erase(entity)
			entity.set_active(true)
			return entity
	return null

func remove_body_part_equipment(body_part : String) -> Array[Entity]:
	var removed = []
	if equippable_body.keys().has(body_part):
		for equipment in equippable_body[body_part]:
			removed.append(remove_equipment(equipment))
	return removed

func remove_all_equipment() -> Array[Entity]:
	var removed = []
	for part in equippable_body:
		removed.append(remove_body_part_equipment(part))
	return removed

func has_equipment(entity : Entity) -> bool:
	for part in equippable_body.values():
		if entity in part:
			return true
	return false
