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
	
	#brain components
	#create and add vision component (eyes)
	var vision_comp_class = ComponentRegistry.get_component_class("VisionComponent")
	if vision_comp_class:
		add_component(vision_comp_class.new(32))
	
	var movement_path_comp_class = ComponentRegistry.get_component_class("MovementPathComponent")
	if movement_path_comp_class:
		add_component(movement_path_comp_class.new())
	
	var target_ent_comp_class = ComponentRegistry.get_component_class("TargetEntityComponent")
	if target_ent_comp_class:
		add_component(target_ent_comp_class.new())
	
	var saught_ent_comp_class = ComponentRegistry.get_component_class("SaughtEntityComponent")
	if saught_ent_comp_class:
		add_component(saught_ent_comp_class.new())
		
	var avail_action_comp_class = ComponentRegistry.get_component_class("AvailableActionsComponent")
	if avail_action_comp_class:
		add_component(avail_action_comp_class.new())
		
	var avail_goal_comp_class = ComponentRegistry.get_component_class("AvailableGoalssComponent")
	if avail_goal_comp_class:
		add_component(avail_goal_comp_class.new())

	var cur_goal_comp_class = ComponentRegistry.get_component_class("CurrentGoalComponent")
	if cur_goal_comp_class:
		var cur_goal_comp : CurrentGoalComponent = cur_goal_comp_class.new()
		cur_goal_comp.goal = TargetItemEquippedGoal.new()
		add_component(cur_goal_comp)
	
	var cur_plan_comp_class = ComponentRegistry.get_component_class("CurrentPlanComponent")
	if cur_plan_comp_class:
		add_component(cur_plan_comp_class.new())

	var sphere_stats = ComponentRegistry.get_component_class("SphereStatsComponent")
	if sphere_stats:
		add_component(sphere_stats.new())

	#play defualt animation
	worker_animated_sprite_2d.play("default")

func chop():
	worker_animated_sprite_2d.play("chop")
