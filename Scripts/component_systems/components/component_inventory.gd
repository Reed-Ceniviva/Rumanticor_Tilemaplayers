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

func remove_item(entity: Entity) -> Entity:
	if entity in items:
		items.erase(entity)
		entity.set_active(true)
		if !entity.has_component_type("PositionComponent"):
			entity.add_component(ComponentRegistry.get_component_class("PositionComponent").new())
		return entity
	return null

func has_item(entity: Entity) -> bool:
	return entity in items

func has_item_amount(entity : Entity, amount : float) -> bool:
	var total = 0
	for item in items:
		if item.get_class() == entity.get_class():
			total += 1
	if total == amount:
		return true
	else:
		return false
		

func clear() -> void:
	items.clear()

func is_full() -> bool:
	return items.size() >= max_items
