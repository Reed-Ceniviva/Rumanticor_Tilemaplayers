extends Node2D
class_name entity_worker

const ComponentMovement = preload("uid://be61wtxi23xna")
const ComponentSight = preload("uid://31t41o312j1g")
const ComponentCharstats = preload("uid://ck7f0jmx20ak5")
const ComponentTasks = preload("uid://bwm3i24hmmubt")
const ComponentInventory = preload("uid://brq0ycbrjbp0i")
const ComponentFamily = preload("uid://cmt2n34ksublh")
@onready var _animated_sprite_2d = $defualt_worker_animated_sprite_2d


var my_layer_manager : layer_manager
var my_movement_component : component_movement
var my_sight_component : component_sight
var my_char_stats : component_charstats
var my_tasks : component_tasks
var my_inventory : component_inventory
var map_location: Vector2i = Vector2i.ZERO
var my_family : component_family

## sets up necassary data for the worker entity
## @param _layer_manager The layer_manager for the world
## sets the component values according to worker defualts
func setup(_layer_manager: layer_manager):
	my_layer_manager = _layer_manager
	
	#give the worker sight
	my_sight_component = ComponentSight.new()
	my_sight_component.setup(32)
	
	#give the worker legs and pathing
	my_movement_component = ComponentMovement.new()
	
	#give the worker an identity
	my_char_stats = ComponentCharstats.new()
	var char_manager = get_parent()
	var char_name : String
	var char_sex : bool
	char_name = my_char_stats.FIRST_NAMES.pick_random()
	char_sex = randi()%2
	my_char_stats.setup(char_name,char_sex,0.0, 0.25, 0.0)
	
	#give the worker processing
	my_tasks = ComponentTasks.new()
	
	#let the worker carry things
	my_inventory = ComponentInventory.new()
	my_inventory.setup(5)
	
	#let the worker have a family including a home
	my_family = ComponentFamily.new()
	
	set_meta("component_sight", my_sight_component)
	set_meta("component_movement", my_movement_component)
	set_meta("component_charstats", my_char_stats)
	set_meta("component_inventory", my_inventory)
	set_meta("component_tasks", my_tasks)
	set_meta("component_family", my_family)
	
	

func _ready():
	add_to_group("ecs_entities")
	
