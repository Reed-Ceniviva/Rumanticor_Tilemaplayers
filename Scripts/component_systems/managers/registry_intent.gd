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



func _ready():
	# Register blueprints here
	register_blueprint("build_hut", {
		"preconditions": [
			#check if the ent has enough logs to build a hut
			{"component": "InventoryComponent", "check":"has_item_amount","args":["LogEntity",5] }
			],
		"fallback_intents": ["collect_logs"]
	})

	register_blueprint("collect_log", {
		"preconditions": [
			#check if a log is in sight
			{"component": "VisionComponent", "check":"type_in_sight","args":["LogEntity"] },
			#check if there is space in inventory to store a log
			{"component": "InventoryComponent", "check":"is_not_full", "args":[]},
			#check if ent is in range to collect a log
			{"component": "PositionComponent", "check":"is_in_grab_range_of_target", "args":[]}
			],
		"fallback_intents": ["fell_tree", "move_to_target"]
	})
#
	register_blueprint("fell_tree", {
		"preconditions": [
			#check if a tree is in sight
			{"component": "VisionComponent", "check":"type_in_sight","args":["TreeEntity"] },
			#check if ent has a weapon
			{"component": "EquipmentComponent", "check":"has_weapon_equipped", "args":[]},
			#check if ent is in range to use weapon
			{"component": "PositionComponent", "check":"is_in_melee_range_of_target" ,"args":["entity", "target"]}
			],
		"fallback_intents": ["find_tree","move_to_target","find_tool"]
	})

	register_blueprint("equip_target_tool",{
		"preconditions":[
			{"component": "VisionComponent", "check":"type_in_sight","args":["ToolEntity"] },
			{"component": "BrainComponent", "check":"knows_not", "args":["target", -1]},
			{"component": "PositionComponent", "check":"is_in_grab_range_of_target", "args":[]},
			{"component": "EquipmentComponent", "check":"non_accessory_equipped", "args":["hand"]}
		],
		"fallback_intents": ["move_to_target", "find_tool", "put_tool_down"]
	})
	
	register_blueprint("find_tool", {
		"preconditions":[
			{"component": "VisionComponent", "check":"type_in_sight","args":["ToolEntity"] },
		],
		"fallback_intents": ["wander"]
	})
	
	register_blueprint("put_tool_down", {
		"preconditions":[],
		"fallback_intents": ["equip_target_tool"]
	})

	register_blueprint("move_to_target", {
		"preconditions": [
			{"component": "BrainComponent", "check":"knows_not", "args":["target", -1]},
			{"component": "BrainComponent", "check":"knows", "args":["traverses"]}
		],
		"fallback_intents": ["rest"]
	})

	register_blueprint("find_tree",{
		"preconditions": [
				{"component": "VisionComponent", "check":"type_in_sight","args":["TreeEntity"] }
			],
		"fallback_intents": ["wander"]
	})
	register_blueprint("wander", {
		"preconditions": [
			{"component":"BrainComponent", "check":"knows", "args":["traverses"]}
			],
		"fallback_intents": ["rest"]  # terminal intent
	})

static func register_blueprint(intent_name: String, blueprint: Dictionary) -> void:
	if not blueprint.has("preconditions"):
		push_warning("Blueprint for '%s' missing 'preconditions'" % intent_name)
	if not blueprint.has("fallback_intents"):
		push_warning("Blueprint for '%s' missing 'fallback_intents'" % intent_name)
	
	blueprints[intent_name] = blueprint

static func get_blueprint(intent_name: String) -> Dictionary:
	return blueprints.get(intent_name, {})
