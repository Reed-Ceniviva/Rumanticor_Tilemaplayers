extends Node2D
class_name entity_worker

const ComponentMovement = preload("uid://be61wtxi23xna")
const ComponentSight = preload("uid://31t41o312j1g")
const ComponentCharstats = preload("uid://ck7f0jmx20ak5")
const ComponentTasks = preload("uid://bwm3i24hmmubt")

var my_layer_manager
var my_movement_component
var my_sight_component
var my_char_stats
var my_tasks
var map_location: Vector2i = Vector2i.ZERO

## sets up necassary data for the worker entity
## @param _layer_manager The layer_manager for the world
## sets the component values according to worker defualts
func setup(_layer_manager: layer_manager):
	my_layer_manager = _layer_manager
	my_sight_component = ComponentSight.new()
	my_sight_component.setup(32)
	my_movement_component = ComponentMovement.new()
	my_movement_component.setup(0.25)
	my_char_stats = ComponentCharstats.new()
	var char_manager = get_parent()
	if char_manager is manager_character:
		my_char_stats.char_name = char_manager.get_rand_name()
	my_char_stats.sex = randi()%2
	my_tasks = ComponentTasks.new()
	set_meta("component_sight", my_sight_component)
	set_meta("component_movement", my_movement_component)
	set_meta("component_charstats", my_char_stats)
	set_meta("component_tasks", my_tasks)
	
	

func _ready():
	add_to_group("ecs_entities")
	
