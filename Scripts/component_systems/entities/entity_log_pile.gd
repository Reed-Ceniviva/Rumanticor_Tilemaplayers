extends Entity
class_name LogPileEntity

func _init(init_log : LogEntity ,init_pos : Vector2i = Vector2i(-1,-1)):
	var pos_comp_class = ComponentRegistry.get_component_class("PositionComponent")
	if pos_comp_class:
		add_component(pos_comp_class.new(init_pos))
	var inv_comp : InventoryComponent = ComponentRegistry.get_component_class("InventoryComponent").new(5)
	inv_comp.add_item(init_log)
	
