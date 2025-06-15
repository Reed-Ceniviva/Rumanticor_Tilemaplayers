extends Node2D
class_name Entity

var components: Dictionary = {}
@export var entity_id: int = -1
var active: bool = true
var tags: Array[String] = []

func add_component(component: Component) -> void:
	components[component.component_name] = component

func get_component_by_type(component_type: String) -> Component:
	return components.get(component_type)

func has_component_type(component_type: String) -> bool:
	return components.has(component_type)

func remove_component_type(component_type: String) -> void:
	components.erase(component_type)

func add_tag(tag: String) -> void:
	if not tags.has(tag):
		tags.append(tag)

func remove_tag(tag: String) -> void:
	tags.erase(tag)

func has_tag(tag: String) -> bool:
	return tags.has(tag)

##bool setter for if an entity should be considered in world state calculations and those entities visability
##
##if the item is set to active the item is set to be visable
##if the item is set to inactive the items' visability is set to false
func set_active(is_active : bool) -> void:
	if is_active:
		active = true
		self.visible = true
	else:
		active = false
		self.visible = false

##function to take care of housekeeping before freeing up an entity
##
##the base die function will empty the contents of an entities inventory into the space that the entity dies before freeing the entity
func die():
	if has_component_type("InventoryComponent"):
		var inv_comp : InventoryComponent = get_component_by_type("InventoryComponen")
		for item in inv_comp.items:
			var dropped_item = inv_comp.remove_item(item)
			get_parent().add_child(dropped_item)
			dropped_item.position = self.position
	self.queue_free()
