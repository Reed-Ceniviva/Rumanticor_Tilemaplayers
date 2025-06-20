extends Node

var entity_registry = EntityRegistry
var component_registry = ComponentRegistry
var action_registry = ActionRegistry
var affordance_registry = AffordanceRegistry

var health_system = HealthSystem.new()
var pos_system = PositionSystem.new()
var vision_system = VisionSystem.new()
var movement_system = MovementSystem.new()
var navigation_system = NavigationSystem.new()
var goap_planner = GOAPPlanner.new()
var goal_selection = GoalSelectionSystem.new()
var goal_generation = GoalGeneratorSystem.new()
var systems_manager = SystemManager.new()

@onready var layer_manager = $Layer_Manager
@onready var entities_layer = $Entities

var map_matrix : Dictionary[Vector2i,Array]

##the world will progress every tick_duration seconds
@export var tick_duration = 0.33
var tick_counter = tick_duration

func _ready():
	systems_manager.register_system(health_system)
	systems_manager.register_system(pos_system)
	systems_manager.register_system(vision_system)
	systems_manager.register_system(movement_system)
	systems_manager.register_system(navigation_system)
	pass

func _physics_process(delta):
	tick_counter -= delta
	if tick_counter <= 0.0:
		tick_counter+=tick_duration
		if layer_manager and map_matrix.is_empty():
			print("getting map and calling place trees")
			map_matrix = layer_manager.get_map()
			pos_system.groundTM = layer_manager.tm_layers["ground"]
			place_trees()
			var worker_ent = EntityRegistry.instantiate_entity("WorkerEntity", [layer_manager.tm_layers["ground"].get_used_cells().min()])
			var axe_ent = EntityRegistry.instantiate_entity("AxeEntity",[layer_manager.tm_layers["ground"].get_used_cells().min() + Vector2i.RIGHT])
			
			entities_layer.add_child(worker_ent)
			entities_layer.add_child(axe_ent)
			
			var worker_equi : EquipmentComponent = worker_ent.get_component_by_type("EquipmentComponent")
			worker_equi.equip_entity(axe_ent)
			
			if worker_ent.has_component_type("TargetEntityComponent"):
				worker_ent.get_component_by_type("TargetEntityComponent").target = axe_ent.entity_id
			else:
				print("worker doesnt have target entity component")
			
			if worker_ent.has_component_type("SaughtEntityComponent"):
				worker_ent.get_component_by_type("SaughtEntityComponent").saught = AxeEntity.new()
			
			if worker_ent.has_component_type("CurrentPlanComponent"):
				worker_ent.get_component_by_type("CurrentPlanComponent").plan = ActionRegistry.get_applicable_actions(worker_ent)
		
		for child in entities_layer.get_children():
			if child is Entity:
				
				if child is WorkerEntity:
					if child.get_component_by_type("TargetEntityComponent").target != -1:
						print("Target = " ,  EntityRegistry._entity_store[child.get_component_by_type("TargetEntityComponent").target])
					pass
					#print(child.get_component_by_type("AvailableActionsComponent").actions)
				
				if child.has_component_type("CurrentPlanComponent"):
					var child_plan : CurrentPlanComponent = child.get_component_by_type("CurrentPlanComponent")
					if child_plan.plan.is_empty():
						goap_planner.make_plan(child)
					else:
						goap_planner.execute_plan(child)
				if child.has_component_type("AvailableActionsComponent"):
					print(child.get_component_by_type("AvailableActionsComponent").actions)
				if child.has_component_type("HealthComponent"):
					health_system.process(child)
				if child.has_component_type("PositionComponent"):
					pos_system.process(child)
				if child.has_component_type("VisionComponent"):
					vision_system.process(child)
				if child.has_component_type("MovementPathComponent"):
					movement_system.process(child)
				if child.has_component_type("EquipmentComponent"):
					print("equippable body: " , child.get_component_by_type("EquipmentComponent").equippable_body)
				if child.has_component_type("CurrentGoalComponent"):
					var goal_comp : CurrentGoalComponent = child.get_component_by_type("CurrentGoalComponent")
					if goal_comp.goal:
						if not goal_comp.goal.is_satisfied(child):
							navigation_system.process_entity(child)
						else:
							goal_selection.process_entity(child)
					else:
						child.get_component_by_type("AvailableGoalsComponent").goals = goal_generation.generate_available_goals(child)
						goal_selection.process_entity(child)
		

func place_trees():
	for pos in map_matrix:
		if map_matrix[pos].has("ground"):
			if randi() % 100 < 1 :
				var tree_ent = EntityRegistry.instantiate_entity("TreeEntity", [pos])
				entities_layer.add_child(tree_ent)
		
