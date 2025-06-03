class_name world_manager
extends Node

@onready var _layer_manager : layer_manager = $Layer_Manager
@onready var camera_2d = $Camera2D
var entity_id_counter = 0
var entity_store : Dictionary [int, Entity]
var tick_interval : = 0.2
var tick_accumulator := 0.0

var BodySystem : SystemBodies

func _init():
	BodySystem = SystemBodies.new(self)

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
	var head_comp = ComponentBodyPart.new(BodyData.PartType.HEAD) 
	var head_part = EntityBodyPart.new(head_comp)
	new_entity_id(head_part)
	#create and add the brain
	var brain_comp = ComponentBodyPart.new(BodyData.PartType.BRAIN)
	var brain_part = EntityBodyPart.new(brain_comp)
	new_entity_id(brain_part)
	head_part.add_child_part(brain_part)
	#Create and add the eyes
	var right_eye_comp = ComponentBodyPart.new(BodyData.PartType.EYE)
	right_eye_comp.side = BodyData.PartSide.RIGHT
	right_eye_comp.face = BodyData.PartFace.FRONT
	var right_eye_part = EntityBodyPart.new(right_eye_comp)
	new_entity_id(right_eye_part)
	head_part.add_child_part(right_eye_part)
	var left_eye_comp = ComponentBodyPart.new(BodyData.PartType.EYE)
	left_eye_comp.side = BodyData.PartSide.LEFT
	left_eye_comp.face = BodyData.PartFace.FRONT
	var left_eye_part = EntityBodyPart.new(right_eye_comp)
	new_entity_id(left_eye_part)
	head_part.add_child_part(left_eye_part)
	#create and add the nose
	var nose_comp = ComponentBodyPart.new(BodyData.PartType.NOSE)
	nose_comp.face = BodyData.PartFace.FRONT
	var nose_part = EntityBodyPart.new(nose_comp)
	new_entity_id(nose_part)
	head_part.add_child_part(nose_part)
