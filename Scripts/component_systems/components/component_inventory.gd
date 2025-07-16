extends Component
class_name InventoryComponent

@export var max_items: int = 10
var items: Array[Entity] = []

func _init(init_max_items : int = max_items, init_items : Array[Entity] = items):
	max_items = init_max_items
	items = init_items
	component_name = "InventoryComponent"
	super._init()

func add_item(entity: Entity) -> bool:
	if items.size() >= max_items:
		return false
	items.append(entity)
	entity.set_active(false)
	if entity.has_component_type("InventoryComponent"):
		if entity.get_component_by_type("InventoryComponent").max_items > 1:
			max_items += 1
	return true

func remove_entity(entity: Entity) -> Entity:
	if entity in items:
		items.erase(entity)
		entity.set_active(true)
		if !entity.has_component_type("PositionComponent"):
			entity.add_component(ComponentRegistry.get_component_class("PositionComponent").new())
		return entity
	return null

func has_entity(entity: Entity) -> bool:
	return entity in items
	
func has_tagged_item(tag : String) -> Entity:
	for item in items:
		if item.has_tag(tag):
			return item
	return null

func num_of_contained_tagged_items(tag: String) ->int:
	var count : int = 0
	for item in items:
		if item.has_tag(tag):
			count = count + 1
	return count

func has_item_amount(ent_type : String, amount : float) -> bool:
	var total = 0
	for item in items:
		if item.get_class() == ent_type:
			total += 1
	if total == amount:
		return true
	else:
		return false
		

func clear() -> void:
	items.clear()

func is_full() -> bool:
	return items.size() >= max_items

func is_not_full() -> bool:
	return not is_full()
