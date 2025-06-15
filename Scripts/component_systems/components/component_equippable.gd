extends Component
class_name EquippableComponent

var equips_to : String = "hand"
var accessory : bool = false

func _init(init_equips_to : String = equips_to, is_accessory : bool = accessory):
	accessory = is_accessory
	equips_to = init_equips_to
	component_name = "EquippableComponent"
	super._init()
