extends Component
class_name EquippableComponent

## Part of the body that the equipment can attach to (e.g. "hand", "head")
var equips_to: String = "hand"

## Whether this is an accessory (e.g. ring, necklace) or a primary equipment
var accessory: bool = false

## Weapon effectiveness multiplier
var damage_mod: float = 1.0

## Defense multiplier when taking damage
var defense_mod: float = 1.0

## Effective melee or usage range
var range: float = 1.0

func _init(init_equips_to: String = "hand", init_is_accessory: bool = false):
	accessory = init_is_accessory
	equips_to = init_equips_to
	component_name = "EquippableComponent"
	super._init()

func get_is_accessory() -> bool:
	return accessory

func set_is_accessory(set_to: bool) -> void:
	accessory = set_to
