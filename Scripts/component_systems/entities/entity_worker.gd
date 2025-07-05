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
	
	#create and add age component
	var age_comp_class = ComponentRegistry.get_component_class("AgeComponent")
	if age_comp_class:
		add_component(age_comp_class.new())
	
	var body_comp_class = ComponentRegistry.get_component_class("BodyComponent")
	if body_comp_class:
		add_component(body_comp_class.new())
	
	var sphere_stats_class = ComponentRegistry.get_component_class("SphereStatsComponent")
	if sphere_stats_class:
		add_component(sphere_stats_class.new())
	
	##intent based AI
	var brain_comp_class = ComponentRegistry.get_component_class("BrainComponent")
	if brain_comp_class:
		var brain_comp : BrainComponent = brain_comp_class.new()
		#intent based AI
		brain_comp.memory["intent"] = "collect wood"
		
		#object permanance
		brain_comp.memory["target_entity"]
		brain_comp.memory["target_entity_id"] = -1
		brain_comp.memory["target_location"] = Vector2i.ZERO
		brain_comp.memory["current_path"] = []
		
		#vision
		brain_comp.memory["in_sight"] = []
		brain_comp.memory["sight_range"] = 32
		#brain_comp.memory["visibility"] = 12 #every twelve tiles halves visibility
		
		#mobility
		brain_comp.memory["traverses"] = {"ground":1.0}
		brain_comp.memory["melee_damage"] = 1.0
		brain_comp.memory["melee_range"] = 1.0
		brain_comp.memory["ranged_range"] = 0.0
		
		add_component(brain_comp)


	##play defualt animation
	worker_animated_sprite_2d.play("default")

func chop():
	worker_animated_sprite_2d.play("chop")
