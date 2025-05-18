extends task
class_name task_chop_tree

func execute(entity) -> bool:
	var sight_component = entity.get_meta("component_sight")
	var inventory_component = entity.get_meta("component_inventory")
	if sight_component == null or sight_component.target_tile == Vector2i(-1, -1):
		return false

	var manager = entity.my_layer_manager
	var current_pos = entity.map_location
	var target_pos = sight_component.target_tile

	if current_pos.distance_to(target_pos) <= 1:
		entity._animated_sprite_2d.play("chop")
		manager.tree_chopped(target_pos)
		
		if not inventory_component.has_item("wood"):
			inventory_component.add_item("wood", 0)
		inventory_component.add_item("wood", 1)
		
		return true

	return false
