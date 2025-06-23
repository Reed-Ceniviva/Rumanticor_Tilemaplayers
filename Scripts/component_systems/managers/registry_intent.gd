extends Node
class_name IntentRegistry

# Each blueprint maps an intent to its requirements and fallback sub-intents
# "intent_name" => Blueprint
static var blueprints: Dictionary = {}

#register_blueprint("build_hut", {
	#"preconditions": [
	#each precondition may correlate to a fallback intention: has_enough_logs -> collect_log, tree_is_in_sight -> find_tree
		#{ "component": "InventoryComponent", "check": "has_item", "args": ["wood", 10] }
	#],
	#"fallback_intents": ["collect_wood"]
#})



func _init():
	# Register blueprints here
	register_blueprint("build_hut", {
		"preconditions": [
			#check if the ent has enough logs to build a hut
			{"component": "InventoryComponent", "check":"has_item_amount","args":["LogEntity",5] }
			],
		"fallback_intents": ["collect_log"]
	})

	register_blueprint("collect_log", {
		"preconditions": [
			#check if a log is in sight
			{"component": "BrainComponent", "check":"log_in_sight","args":[] },
			#check if there is space in inventory to store a log
			{"component": "InventoryComponent", "check":"is_not_full", "args":[]},
			#check if ent is in range to collect a log
			{"component": "PositionComponent", "check":"is_in_grab_range_of_target", "args":["target"]}
			],
		"fallback_intents": ["find_log","fell_tree", "move_to_target"]
	})
#
	register_blueprint("fell_tree", {
		"preconditions": [
			#check if a tree is in sight
			{"component": "BrainComponent", "check":"tree_in_sight","args":[] },
			#check if ent has a weapon
			{"component": "EquipmentComponent", "check":"has_weapon_equipped", "args":[]},
			#check if ent is in range to use weapon
			{"component": "PositionComponent", "check":"is_in_melee_range_of_target" ,"args":["entity", "target"]}
			],
		"fallback_intents": ["find_tool","find_tree","move_to_target"]
	})

	register_blueprint("equip_target_tool",{
		"preconditions":[
			{"component": "BrainComponent", "check":"tool_in_sight","args":[] },
			{"component": "PositionComponent", "check":"is_in_grab_range_of_target", "args":["target"]},
			{"component": "EquipmentComponent", "check":"non_accessory_equipped", "args":["hand"]}
		],
		"fallback_intents": ["move_to_target", "find_tool", "put_tool_down"]
	})
	
	register_blueprint("find_tool", {
		"preconditions":[
			{"component": "BrainComponent", "check":"tool_in_sight","args":[] }
		],
		"fallback_intents": ["wander"]
	})
	
	register_blueprint("put_tool_down", {
		"preconditions":[],
		"fallback_intents": ["equip_target_tool"]
	})

	register_blueprint("move_to_target", {
		"preconditions": [
			{"component": "BrainComponent", "check":"knows", "args": ["target"]},
			{"component": "BrainComponent", "check":"knows", "args":["traverses"]},
			{"component": "PositionComponent", "check":"not_at_target_position", "args":["target"]}
		],
		"fallback_intents": ["rest"]
	})

	register_blueprint("find_tree",{
		"preconditions": [
				{"component": "BrainComponent", "check":"tree_in_sight","args":[] }
			],
		"fallback_intents": ["find_tool","wander"]
	})
	register_blueprint("wander", {
		"preconditions": [
			{"component":"BrainComponent", "check":"knows", "args":["traverses"]}
			],
		"fallback_intents": []  # terminal intent
	})
	register_blueprint("rest", {
		"preconditions": [],
		"fallback_intents": []  # terminal intent
	})
	register_blueprint("find_log",{
		"preconditions": [
				{"component": "BrainComponent", "check":"log_in_sight","args":[] }
			],
		"fallback_intents": ["find_tree","wander"]
	})

static func register_blueprint(intent_name: String, blueprint: Dictionary) -> void:
	if not blueprint.has("preconditions"):
		push_warning("Blueprint for '%s' missing 'preconditions'" % intent_name)
	if not blueprint.has("fallback_intents"):
		push_warning("Blueprint for '%s' missing 'fallback_intents'" % intent_name)
	
	blueprints[intent_name] = blueprint

static func get_blueprint(intent_name: String) -> Dictionary:
	return blueprints.get(intent_name, {})
