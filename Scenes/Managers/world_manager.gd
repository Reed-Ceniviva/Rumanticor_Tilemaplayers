class_name world_manager
extends Node

@onready var _layer_manager : layer_manager = $Layer_Manager
@onready var camera_2d = $Camera2D
var entity_id_counter = 0
var entity_store : Dictionary [int, Entity]
var tick_interval : = 0.2
var tick_accumulator := 0.0
@onready var body_system : SystemBodies = $Systems/BodiesSystem
const WORKER = preload("uid://bjhfcpircke4c")
const ENTITY_BODY = preload("uid://238jfxvsma1w")

func _init():
	pass

func new_entity_id(entity : Entity) -> int:
	entity.set_world_manager(self)
	var return_id = entity_id_counter
	entity_id_counter += 1
	entity_store[return_id] = entity
	entity.entity_id = return_id
	return return_id

func _physics_process(delta):
	tick_accumulator += delta
	while tick_accumulator >= tick_interval:
		_tick_process()
		tick_accumulator -= tick_interval


func _tick_process():
	build_worker()
	for id in entity_store:
		if entity_store[id].has_component("position"):
			#print("has position")
			entity_store[id].position = _layer_manager.tm_layers["ground"].map_to_local(entity_store[id].get_component("position").my_position)
		if entity_store[id].has_component("age"):
			var age_comp : ComponentAge = entity_store[id].get_component("age")
			age_comp.current_age += tick_interval*(age_comp.aging_speed)

func _on_layer_manager_ready():
	_layer_manager = $Layer_Manager
	var entity_tml = _layer_manager.tm_layers["entities"]
	for entity in entity_tml.get_children():
		if entity is Entity:
			entity_store[entity.entity_id] = entity

func build_worker():
	#Create the head
	var body = body_system.build_base_person_body()
	var new_worker = WORKER.instantiate()
	new_worker.body = body
	new_worker.setup(ComponentPosition.new(Vector2i(1,1)))
	_layer_manager.find_child("entities").add_child(new_worker)
	
	
