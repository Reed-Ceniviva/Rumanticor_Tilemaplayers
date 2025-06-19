extends Component
class_name EquippableComponent

##part of the body that the equipment can equip to
var equips_to : String = "hand"
##if this is an accessory or equipment, ring vs sword
var accessory : bool = false
##how affective this equipment is when weilded as a weapon
var damage_mod : float = 1.0
##how affective this equipment is at taking an attack
var defense_mod : float = 1.0
##how far away the item can be used to attack properly
var range : float = 1.0

func _init(init_equips_to : String = equips_to, is_accessory : bool = accessory):
	accessory = is_accessory
	equips_to = init_equips_to
	component_name = "EquippableComponent"
	super._init()
