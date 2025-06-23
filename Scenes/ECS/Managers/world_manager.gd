extends Node

var entity_registry = EntityRegistry
var component_registry = ComponentRegistry
var affordance_registry = AffordanceRegistry

var health_system = HealthSystem.new()
var pos_system = PositionSystem.new()
var vision_system = VisionSystem.new()
var movement_system = MovementSystem.new()
var navigation_system = NavigationSystem.new()
var systems_manager = SystemManager.new()
var damage_system = DamageSystem.new()
var intent_propagator = IntentPropagationSystem.new()

@onready var layer_manager : layer_manager = $Layer_Manager
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
			navigation_system.terrain_map = map_matrix
			pos_system.groundTM = layer_manager.tm_layers["ground"]
			place_trees()
			var worker_ent = EntityRegistry.instantiate_entity("WorkerEntity", [layer_manager.tm_layers["ground"].get_used_cells().min()])
			var axe_ent = EntityRegistry.instantiate_entity("AxeEntity",[layer_manager.tm_layers["ground"].get_used_cells().min() + Vector2i.RIGHT])
			
			entities_layer.add_child(worker_ent)
			entities_layer.add_child(axe_ent)
			
			#var worker_equi : EquipmentComponent = worker_ent.get_component_by_type("EquipmentComponent")
			#worker_equi.equip_entity(axe_ent)
		
		for child in entities_layer.get_children():
			if child is Entity:
				
				if child is WorkerEntity:
					if child.get_component_by_type("TargetEntityComponent").target != -1:
						print("Target = " ,  EntityRegistry._entity_store[child.get_component_by_type("TargetEntityComponent").target])
					pass
					#print(child.get_component_by_type("AvailableActionsComponent").actions)
				if child.has_component_type("HealthComponent"):
					health_system.process(child)
				if child.has_component_type("PositionComponent"):
					pos_system.process(child)
				if child.has_component_type("BrainComponent"):
					var brain : BrainComponent = child.get_component_by_type("BrainComponent")
					intent_propagator.process(child)
					var intent = brain.recall("intent", "rest")
					
					print("intent: " , intent)
					
					if brain.knows("in_sight"):
						vision_system.process(child)
					if brain.knows("current_path"):
						movement_system.process(child)
					
					match intent:
						"find_tree":
							print("finding tree")
							for vis_ent_id in brain.recall("in_sight", []):
								var vis_ent = EntityRegistry._entity_store[vis_ent_id]
								if vis_ent.has_tag("tree"):
									brain.remember("target", vis_ent_id)
									brain.remember("intent", "move_to_target")
							
							
						"fell_tree":
							print("felling tree")
							var target_ent : Entity = EntityRegistry._entity_store[brain.recall("target", -1)]
							print(target_ent)
							var tree_health : HealthComponent =	target_ent.get_component_by_type("HealthComponent")
							damage_system.process(child)
							var damage_output = brain.recall("melee_damage", 1.0)
							tree_health.take_damage(damage_output)
							
						"collect_log":
							print("collecting log")
							var inv_comp : InventoryComponent = child.get_component_by_type("InventoryComponent")
							var target_ent : Entity = EntityRegistry._entity_store[brain.recall("target", -1)]
							inv_comp.add_item(target_ent)
							
						"build_hut":
							print("building hut")
							var pos_comp : PositionComponent = child.get_component_by_type("PositionComponent")
							var rand_neighbor = layer_manager.tm_layers["ground"].get_surrounding_cells(pos_comp.pos).pick_random()
							entities_layer.add_chhild(EntityRegistry.instantiate_entity("HutEntity", rand_neighbor))
							
						"find_tool":
							print("finding tool")
							for vis_ent_id in brain.recall("in_sight", []):
								var vis_ent = EntityRegistry._entity_store[vis_ent_id]
								if vis_ent.has_component_type("EquippableComponent"):
									if not vis_ent.get_component_by_type("EquippableComponent").accessory:
										brain.remember("target", vis_ent_id)
										brain.remember("intent","equip_target_tool")
										break
							
						"put_tool_down":
							print("putting down tools")
							var equi_comp : EquipmentComponent = child.get_component_by_type("EquipmentComponent")
							equi_comp.remove_all_non_accessories()
							
						"wander":
							print("wandering")
							var pos_comp : PositionComponent = child.get_component_by_type("PositionComponent")
							var rand_neighbor = layer_manager.tm_layers["ground"].get_surrounding_cells(pos_comp.pos).pick_random()
							brain.remember("target", -1)
							brain.remember("target_location", rand_neighbor)
							navigation_system.process_entity(child)
							#print("child path: " , child.get_component_by_type("BrainComponent").memory["current_path"])
							
						"move_to_target":
							print("Moving to Target")
							if brain.knows("current_path") and brain.knows("traverses"):
								if brain.recall("current_path", []).is_empty():
									navigation_system.process_entity(child)
								
						"equip_target_tool":
							print("Equipping Target Tool")
							var equi_comp : EquipmentComponent = child.get_component_by_type("EquipmentComponent")
							var target_ent : Entity = EntityRegistry._entity_store[brain.recall("target", -1)]
							equi_comp.equip_entity(target_ent)
							pass
							
						"rest":
							print("resting")
							pass
						
						"find_log":
							print("finding log")
							for vis_ent_id in brain.recall("in_sight", []):
								var vis_ent = EntityRegistry._entity_store[vis_ent_id]
								if vis_ent.has_component_type("ResourceComponent"):
									if vis_ent.get_component_by_type("ResourceComponent").type == "wood":
										brain.remember("target", vis_ent_id)
										brain.remember("intent","move_to_target")
										break

func place_trees():
	for pos in map_matrix:
		if map_matrix[pos].has("ground"):
			if randi() % 100 < 1 :
				var tree_ent = EntityRegistry.instantiate_entity("TreeEntity", [pos])
				entities_layer.add_child(tree_ent)
		
