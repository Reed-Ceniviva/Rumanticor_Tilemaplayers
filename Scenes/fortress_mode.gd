extends Node2D
class_name FortressMode

var fortress_layer_manager : layer_manager
var tick_counter = 0.0
var tick_duration = 0.33

var health_system = HealthSystem.new()
var pos_system = PositionSystem.new()

var vision_system = VisionSystem.new()
var movement_system = MovementSystem.new()
var damage_system = DamageSystem.new()
var navigation_system = NavigationSystem.new()


var entities_layer : TileMapLayer

const CHARACTER_CREATION_SCENE = preload("res://Scenes/character_creation_scene.tscn")
const WORKER_ENTITY = preload("res://Scenes/ECS/Entities/worker_entity.tscn")

func _on_texture_button_pressed():
	var char_creation = CHARACTER_CREATION_SCENE.instantiate()
	char_creation.connect("char_submitted",new_char)
	add_child(char_creation)

func _physics_process(delta):
	if fortress_layer_manager == null:
		for child in get_children():
			if child is layer_manager:
				fortress_layer_manager = child
		if fortress_layer_manager != null:
			entities_layer = fortress_layer_manager.tm_layers["entities"]
			pos_system.groundTM = fortress_layer_manager.tm_layers["ground"]
			navigation_system.terrain_map = fortress_layer_manager.get_map()
			print("layer manager assigned")
	else:
		tick_counter -= delta
		if tick_counter <= 0.0:
			tick_counter+=tick_duration
			for child in entities_layer.get_children():
				if child is Entity:
						#print(child.get_component_by_type("AvailableActionsComponent").actions)
					if child.has_component_type("HealthComponent"):
						#print("calling health system")
						health_system.process(child)
					if child.has_component_type("PositionComponent"):
						#print("calling position system")
						pos_system.process(child)
					if child.has_component_type("BrainComponent"):
						var brain : BrainComponent = child.get_component_by_type("BrainComponent")
						if brain.knows("intent"):
							if brain.recall("intent", "") == "collect_wood":
								var target_wood = EntityRegistry._entity_store[brain.recall("target_entity_id",0)]
								if target_wood.has_matching_component_value("ResourceComponent","type","wood"):
									var wood_pos : Vector2i = target_wood.get_component_by_type("PositionComponent").pos
									var child_pos : Vector2i = child.get_component_by_type("PositionComponent").pos
									if wood_pos.distance_to(child_pos) < 2:
										var child_inv : InventoryComponent = child.get_component_by_type("InventoryComponent")
										child_inv.add_item(target_wood)
										if child_inv.is_full():
											if brain.knows("log_pile_loc"):
												brain.intent_changed("store_wood")
											else:
												brain.intent_changed("make_wood_pile")
										else:
											brain.intent_changed("collect_wood")
									else:
										print("not close enough to collect the wood")
										brain.intent_changed("find_wood")
								else:
									print("target entity is not a wood resource")
									brain.intent_changed("find_wood")
								
							if brain.recall("intent", "") == "store_wood":
								pass
							if brain.recall("intent", "") == "make_wood_pile":
								var creator_inv : InventoryComponent = child.get_component_by_type("InventoryComponent")
								var has_log = creator_inv.get_item_with_matching_comp(ResourceComponent.new("wood"))
								if has_log != null:
									creator_inv.remove_item(has_log)
									var creator_pos = child.get_component_by_type("PositionComponent").pos
									var init_log = has_log
									var log_pile_pos = creator_pos + Vector2i.RIGHT
									var wood_pile_ent = EntityRegistry.instantiate_entity("LogPileEntity", [init_log, log_pile_pos])
									brain.remember("log_pile_loc", log_pile_pos)
									entities_layer.add_child(wood_pile_ent)
								else:
									print("no log in the entities inventory")
									brain.intent_changed("find_wood")
								
							if brain.recall("intent", "") == "find_wood":
								var ent_in_sight =  brain.recall("in_sight",[])
								for ent_id in ent_in_sight:
									var ent = EntityRegistry._entity_store[ent_id]
									if ent.has_matching_component_value("Resource","type","wood"):
										if ent is LogEntity:
											brain.remember("target_entity_id", ent_id)
											brain.intent_changed("move_to_target")
											break
										else:
											print("entity not LogEntity")
									else:
										print("entity doesn't have resource component of type wood")
								print("no wood found")
								brain.intent_changed("find_tree")
							if brain.recall("intent", "") == "find_axe":
								var ent_in_sight =  brain.recall("in_sight",[])
								for ent_id in ent_in_sight:
									if EntityRegistry._entity_store[ent_id] is AxeEntity:
										brain.remember("target_entity_id", ent_id)
										brain.intent_changed("move_to_target")
										break
									else:
										print("ent in sight not AxeEntity")
								print("no axe in sight")
								brain.intent_changed("wonder")
							if brain.recall("intent", "") == "equip_axe":
								var target_axe = EntityRegistry._entity_store[brain.recall("target_entity_id", 0)]
								var axe_pos : Vector2i = target_axe.get_component_by_type("PositionComponent").pos
								if axe_pos.distance_to(child.get_component_by_type("PositionComponent").pos) < 2:
									var equi_comp : EquipmentComponent = child.get_component_by_type("EquipmentComponent")
									if not equi_comp.equip_entity(target_axe):
										print("unable to equip axe")
									else:
										brain.intent_changed("fell_tree")
								else:
									print("axe not in distance to equip")
									brain.intent_changed("find_axe")
							if brain.recall("intent", "") == "fell_tree":
								var target_tree = EntityRegistry._entity_store[brain.recall("target_entity_id", 0)]
								if target_tree is TreeEntity:
									var tree_pos : Vector2i = target_tree.get_component_by_type("PositionComponent").pos
									if tree_pos.distance_to(child.get_component_by_type("PositionComponent").pos) < 2:
										damage_system.process(child)
										var tree_health : HealthComponent = target_tree.get_component_by_type("HealthComponent")
										tree_health.take_damage(brain.recall("melee_damage"))
									else:
										print("not close enough to a tree to fell it")
									
								else:
									print("target entity id does not match to a TreeEntity in the entity store")
										
							if brain.recall("intent", "") == "find_tree_in_sight":
								var ent_in_sight = brain.recall("in_sight", [])
								for ent_id in ent_in_sight:
									if EntityRegistry._entity_store[ent_id] is TreeEntity:
										brain.remember("target_entity_id", ent_id)
										break
										
								print("no tree in sight")
							if brain.recall("intent", "") == "move_to_target":
								var cur_path = brain.recall("current_path")
								if cur_path.is_empty():
									navigation_system.process_entity(child)
							if brain.recall("intent", "") == "wonder":
								print("intent is wonder")
								brain.remember("target_location", child.get_component_by_type("PositionComponent").pos + [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT].pick_random())
								navigation_system.process_entity(child)
						if brain.knows("in_sight"):
							vision_system.process(child)
						if brain.knows("current_path"):
							if not brain.recall("current_path", []).is_empty():
								movement_system.process(child)
							else:
								if brain.recall("last_intent", "wonder") == "find_tree_in_sight":
									brain.intent_changed("fell_tree")
								if brain.recall("last_intent", "wonder") == "find_axe":
									brain.intent_changed("equip_axe")
								if brain.recall("last_intent", "wonder") == "find_wood":
									brain.intent_changed("collect_wood")
					


func new_char(stats : Dictionary):
	print(stats)
	#create new worker
	var starting_pos = fortress_layer_manager.tm_layers["ground"].get_used_cells().min()
	var new_worker : WorkerEntity = EntityRegistry.instantiate_entity("WorkerEntity", [starting_pos])
	fortress_layer_manager.tm_layers["entities"].add_child(new_worker)
	#assign the worker their sphere stats
	var sphere_stats : SphereStatsComponent = new_worker.get_component_by_type("SphereStatsComponent")
	for sphere in sphere_stats.stats.keys():
		print("checking for sphere: ", sphere)
		if stats.keys().has(sphere):
			print("assigning sphere: ", sphere)
			sphere_stats.stats[sphere] = stats[sphere]
		
	#assign age
	var age_comp : AgeComponent = new_worker.get_component_by_type("AgeComponent")
	age_comp.age = stats["age"]
	
	#assign height and weight
	var body_comp : BodyComponent = new_worker.get_component_by_type("BodyComponent")
	body_comp.height = stats["height"]
	body_comp.weight = stats["weight"]
	
	var brain_comp : BrainComponent = new_worker.get_component_by_type("BrainComponent")
	brain_comp.remember("name", stats["name"])
	
	
