extends ToolEntity
class_name AxeEntity

@onready var animated_sprite_2d = $AnimatedSprite2D

func _init(init_pos : Vector2i = Vector2i(-1,-1)):
	super._init(init_pos)

func _ready():
	var equippable_comp : EquippableComponent = ComponentRegistry.get_component_class("EquippableComponent").new("hand",false)
	equippable_comp.damage_mod = 10.0
	equippable_comp.defense_mod = 5.0
	equippable_comp.range = 2.0
	equippable_comp.accessory = false
	add_component(equippable_comp)
	add_tag("axe")
