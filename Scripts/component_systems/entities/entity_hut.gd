extends Entity
class_name HutEntity

func _ready():
	#add_component(ComponentRegistry.get_component_class("ResourceComponent").new("wood"))
	add_tag("hut")
