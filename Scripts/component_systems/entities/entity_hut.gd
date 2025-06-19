extends Entity
class_name HutEntity

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	#add_component(ComponentRegistry.get_component_class("ResourceComponent").new("wood"))
	add_component(ComponentRegistry.get_component_class("StructureComponent").new())
	
	add_component(ComponentRegistry.get_component_class("InventoryComponent").new(5))
	
	animated_sprite_2d.play("default")
	
	add_tag("hut")
