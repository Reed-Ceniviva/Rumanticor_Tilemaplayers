extends Entity
class_name HutEntity

@onready var animated_sprite_2d = $AnimatedSprite2D

func _init(init_pos : Vector2i = Vector2i(-1,-1)):
	var pos_comp_class = ComponentRegistry.get_component_class("PositionComponent")
	if pos_comp_class:
		add_component(pos_comp_class.new(init_pos))

func _ready():
	#add_component(ComponentRegistry.get_component_class("ResourceComponent").new("wood"))
	add_component(ComponentRegistry.get_component_class("StructureComponent").new())
	add_component(ComponentRegistry.get_component_class("DomacileComponent").new())
	add_component(ComponentRegistry.get_component_class("InventoryComponent").new(5))
	
	animated_sprite_2d.play("default")
	
	add_tag("hut")
