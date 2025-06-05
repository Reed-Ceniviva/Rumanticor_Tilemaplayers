extends System
class_name SystemContainers

@onready var shape_data := ShapeData.new()  # or preload/autoload if globally available
@onready var world_manager = $"../.."

func get_total_used_volume(container : ComponentContainer) -> float:
	return container.current_volume

func get_new_used_volume(container: ComponentContainer) -> float:
	var total := 0.0
	for entity_id in container.contents:
		var shape_component = world_manager.entity_store[entity_id].get_component("shape")
		if shape_component:
			var args = shape_component.get_volume_args()
			var shape_type = shape_component.shape_type

			match container.mode:
				"random":
					total += shape_data.get_rand_volume(shape_type, args)
				"organized":
					total += shape_data.get_organized_volume(shape_type, args)
				_:
					total += shape_data.get_volume(shape_type, args)  # fallback
	if total < container.current_volume:
		return total
	else:
		print("failed to rearrange the items better")
		return container.current_volume


func get_remaining_volume(container: ComponentContainer) -> float:
	return container.max_volume - container.current_volume


func can_fit(container: ComponentContainer, entity: Entity) -> float:
	var shape_component = entity.get_component("shape")
	if not shape_component:
		push_warning("Entity lacks ComponentShape")
		return false
	
	var args = shape_component.get_volume_args()
	var shape_type = shape_component.shape_type
	
	var volume
	match container.mode:
		"random": volume = shape_data.get_rand_volume(shape_type, args)
		"organized": volume = shape_data.get_organized_volume(shape_type, args)
		_: volume = shape_data.get_volume(shape_type, args)
	
	if volume <= get_remaining_volume(container):
		return volume
	else:
		return false


func try_add_item(container: ComponentContainer, entity: Entity) -> bool:
	if container.contents.has(entity.entity_id):
		push_warning("Entity already in container.")
		return false
	var fit_vol = can_fit(container, entity)
	if not fit_vol:
		return false
	container.contents[entity.entity_id] = fit_vol
	container.current_volume = clamp(container.current_volume + fit_vol, 0.0, container.max_volume)
	return true


func remove_item(container: ComponentContainer, entity: Entity) -> bool:
	if entity.entity_id in container.contents:
		var ent_vol = container.contents[entity.entity_id]
		container.contents.erase(entity.entity_id)
		container.current_volume -= ent_vol
		return true
	return false


func clear(container: ComponentContainer) -> void:
	container.contents.clear()
	container.current_volume = 0
