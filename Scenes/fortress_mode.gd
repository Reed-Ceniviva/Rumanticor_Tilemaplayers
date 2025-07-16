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
								pass
							if brain.recall("intent", "") == "make_wood_pile":
								var creator_inv : InventoryComponent = child.get_component_by_type("InventoryComponent")
								var has_log = creator_inv.has_item_with_tag("log")
								if has_log != null:
									creator_inv.remove_item(has_log)
									var creator_pos = child.get_component_by_type("PositionComponent").pos
									var init_log = has_log
									var wood_pile_ent = EntityRegistry.instantiate_entity("LogPileEntity", [creator_pos + Vector2i.RIGHT])
									entities_layer.add_child(wood_pile_ent)
								
							if brain.recall("intent", "") == "find_wood":
								pass
							if brain.recall("intent", "") == "fell_tree":
								pass
							if brain.recall("intent", "") == "find_tree_in_sight":
								var ent_in_sight = brain.recall("in_sight", [])
								for ent_id in ent_in_sight:
									if EntityRegistry._entity_store[ent_id] is TreeEntity:
										brain.remember("target_entity_id", ent_id)
								print("no tree in sight")
							if brain.recall("intent", "") == "wonder":
								print("intent is wonder")
								brain.remember("target_location", child.get_component_by_type("PositionComponent").pos + [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT].pick_random())
								navigation_system.process_entity(child)
						if brain.knows("in_sight"):
							vision_system.process(child)
						if brain.knows("current_path"):
							movement_system.process(child)
					


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
	
	
