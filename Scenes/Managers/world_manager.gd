class_name world_manager
extends Node

@onready var _layer_manager : layer_manager = $Layer_Manager
@onready var camera_2d = $Camera2D
var entity_id_counter = 0
var entity_store : Dictionary [int, Entity]
@export var tick_interval : = 0.33
var tick_accumulator := 0.0
@onready var body_system : SystemBodies = $Systems/BodiesSystem
const WORKER = preload("uid://bjhfcpircke4c")
const ENTITY_BODY = preload("uid://238jfxvsma1w")
var year_of_ticks = 10512000.0
var layer_manager_ready = false
const ShapeData = preload("uid://c3aevfujto4dy")
@onready var growth_system = $Systems/GrowthSystem

var worker_count = 0
var _ShapeData : ShapeData

func _init():
	_layer_manager = $Layer_Manager
	_ShapeData = ShapeData.new()

func new_entity_id(entity : Entity) -> int:
	entity.set_world_manager(self)
	var return_id = entity_id_counter
	entity_id_counter += 1
	entity_store[return_id] = entity
	entity.entity_id = return_id
	if layer_manager_ready:
		_layer_manager.find_child("entities").add_child(entity)
	return return_id

func _physics_process(delta):
	tick_accumulator += delta
	while tick_accumulator >= tick_interval:
		_tick_process()
		tick_accumulator -= tick_interval


func _tick_process():
	if layer_manager_ready:
		if worker_count < 1:
			build_worker()
			worker_count += 1
		for id in entity_store:
			if entity_store[id].has_component("position") and entity_store[id].position == Vector2.ZERO:
				entity_store[id].position = _layer_manager.tm_layers["ground"].map_to_local(entity_store[id].get_component("position").my_position)
			if entity_store[id].has_component("age"):
				entity_store[id].get_component("age").current_age += tick_interval*(entity_store[id].get_component("age").aging_speed)
			if entity_store[id] is EntityBody and entity_store[id].has_component("blueprint"):
				if !entity_store[id].shaped:
					entity_store[id].shaped = true
					for part in entity_store[id].get_all_parts():
						if part:
							if part.has_component("shape") and !part.get_component("shape").shape_args:
								var blueprint : ComponentBlueprint = entity_store[id].get_component("blueprint")
								part.get_component("shape").shape_args = blueprint.get_part_shape_args(part.get_type(), entity_store[id].height)
				if entity_store[id].has_component("growth"):
					growth_system.grow(entity_store[id])
				

func _on_layer_manager_ready():
	_layer_manager = $Layer_Manager
	var entity_tml = _layer_manager.tm_layers["entities"]
	for entity in entity_tml.get_children():
		if entity is Entity:
			entity_store[entity.entity_id] = entity
	layer_manager_ready = true

func build_worker():
	var body = body_system.build_base_person_body()
	new_entity_id(body)
	var new_worker = WORKER.instantiate()
	new_entity_id(new_worker)
	new_worker.body = body
	new_worker.setup(ComponentPosition.new(Vector2i(1,1)), body)
	
