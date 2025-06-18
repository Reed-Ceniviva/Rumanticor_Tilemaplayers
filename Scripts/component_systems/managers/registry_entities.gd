extends Node
class_name EntityRegistry

static var entity_uids: Dictionary = {
	"LogEntity" : preload("uid://dk4fpumc7rmbv"),
	"TreeEntity" : preload("uid://tukn3gx6b3qm"),
	"WorkerEntity": preload("uid://cpek715cejdle"),
	"AxeEntity":preload("uid://dhr7wyxix5wed"),
	"HutEntity":preload("uid://5jpxrh5cwuy8")
}  # name : scene preload

static var _entity_store : Dictionary[int,Entity]

static var _entity_counter: int = 0

static func generate_entity_id() -> int:
	_entity_counter += 1
	return _entity_counter

static func instantiate_entity(name_entity: String, init_args: Array = []) -> Entity:
	if not entity_uids.has(name_entity):
		push_error("Entity UID key '%s' not found in EntityRegistry." % name_entity)
		return null

	var packed_scene: PackedScene = entity_uids[name_entity]
	var entity: Entity = packed_scene.instantiate()

	entity.entity_id = generate_entity_id()
	_entity_store[entity.entity_id] = entity

	if init_args.size() > 0 and entity.has_method("_init"):
		entity.callv("_init", init_args)

	return entity
