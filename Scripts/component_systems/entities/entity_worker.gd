extends Entity
class_name WorkerEntity

@onready var worker_animated_sprite_2d : AnimatedSprite2D = $defualt_worker_animated_sprite_2d

# Life Goals
# shelter, food, water - well being
# safety
# social
# self esteem
# self actualization

func _init(init_pos : Vector2i = Vector2i(-1,-1)):
	var pos_comp_class = ComponentRegistry.get_component_class("PositionComponent")
	if pos_comp_class:
		add_component(pos_comp_class.new(init_pos))

func _ready():
	##body components
	#create and add health component
	var health_comp_class = ComponentRegistry.get_component_class("HealthComponent")
	if health_comp_class:
		add_component(health_comp_class.new(100,100))
	
	#create and add inventory component (hands)
	var inv_comp_class = ComponentRegistry.get_component_class("InventoryComponent")
	if inv_comp_class:
		add_component(inv_comp_class.new(2))
		
	#create and add equipment component (hands/back)
	var equipment_comp_class = ComponentRegistry.get_component_class("EquipmentComponent")
	if equipment_comp_class:
		add_component(equipment_comp_class.new())
		
	var mobility_comp_class = ComponentRegistry.get_component_class("MobilityComponent")
	if mobility_comp_class:
		add_component(mobility_comp_class.new())
	
	
	##brain components
	#create and add vision component (eyes)
	
	var target_ent_comp_class = ComponentRegistry.get_component_class("TargetEntityComponent")
	if target_ent_comp_class:
		add_component(target_ent_comp_class.new())
	
	##intent based AI
	var brain_comp_class = ComponentRegistry.get_component_class("BrainComponent")
	if brain_comp_class:
		var brain_comp : BrainComponent = brain_comp_class.new()
		brain_comp.memory["life_goals"] = ["own_home","reproduce"]
		brain_comp.memory["goal_intent"] = ""
		brain_comp.memory["intent"] = ""
		brain_comp.memory["target"] = -1
		brain_comp.memory["in_sight"] = []
		brain_comp.memory["sight_range"] = 32
		brain_comp.memory["current_path"] = []
		brain_comp.memory["traverses"] = {"ground":1.0}
		brain_comp.memory["sphere_stats"] = {
			"strength" : 1.0,
			"nature": 1.0,
			"art": 1.0,
			"social": 1.0,
			"inspiration":1.0,
			"fear":1.0,
			"luck":1.0,
			"wisdom":1.0
		}
		add_component(brain_comp)


	##play defualt animation
	worker_animated_sprite_2d.play("default")

func chop():
	worker_animated_sprite_2d.play("chop")
