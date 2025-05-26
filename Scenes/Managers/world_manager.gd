extends Node

@onready var _layer_manager : layer_manager = $Layer_Manager
@onready var camera_2d = $Camera2D
var entity_id_counter = 0
var entity_store : Dictionary [int, EntityBase]
var tick_interval : = 0.2
var tick_accumulator := 0.0

func new_entity_id(entity : EntityBase) -> int:
	var return_id = entity_id_counter
	entity_id_counter += 1
	entity_store[return_id] = entity
	return return_id

func _physics_process(delta):
	tick_accumulator += delta
	while tick_accumulator >= tick_interval:
		_tick_process()
		tick_accumulator -= tick_interval


func _tick_process():
	for id in entity_store:
		if entity_store[id].has_component("position"):
			print("has position")
			entity_store[id].position = _layer_manager.tm_layers["ground"].map_to_local(entity_store[id].get_component("position").my_position)

func _on_layer_manager_ready():
	_layer_manager = $Layer_Manager
	var entity_tml = _layer_manager.tm_layers["entities"]
	for entity in entity_tml.get_children():
		if entity is EntityBase:
			entity_store[entity.entity_id] = entity
