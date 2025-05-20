extends task
class_name task_build_hut



func execute(entity) -> bool:
	task_type = "build_hut"
	
	var sight_component = entity.get_meta("component_sight")
	var inventory_component : component_inventory = entity.get_meta("component_inventory")
	if sight_component == null or sight_component.target_tile == Vector2i(-1, -1):
		return false

	var manager : layer_manager = entity.my_layer_manager
	var current_pos = entity.map_location
	var target_pos = sight_component.target_tile
	
	if not inventory_component.has_item("wood"):
		return false
	

	if current_pos.distance_to(target_pos) <= 1 and inventory_component.get_item_count("wood") >= 5:
		entity._animated_sprite_2d.play("chop")
		manager.hut_built(target_pos)
		entity.get_meta("component_family").home = target_pos
		inventory_component.remove_item("wood",5)
		return true

	return false
