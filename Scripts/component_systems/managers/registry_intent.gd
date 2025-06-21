extends Node
class_name IntentRegistry

# Each blueprint maps an intent to its requirements and fallback sub-intents
# "intent_name" => Blueprint
static var blueprints: Dictionary = {}

#register_blueprint("build_hut", {
	#"preconditions": [
		#{ "component": "InventoryComponent", "check": "has_item", "args": ["wood", 10] }
	#],
	#"fallback_intents": ["collect_wood"]
#})



func _ready():
	# Register blueprints here
	register_blueprint("build_hut", {
		"preconditions": [
			{"component": "InventoryComponent", "check":"has_item_amount","args":[LogEntity.new(),5] }
			],
		"fallback_intents": ["collect_logs"]
	})

	register_blueprint("collect_logs", {
		"preconditions": [
			{"component": "VisionComponent", "check":"type_in_sight","args":[LogEntity.new()] }
			],
		"fallback_intents": ["fell_tree"]
	})
#
	register_blueprint("fell_tree", {
		"preconditions": [
			{"component": "VisionComponent", "check":"type_in_sight","args":[TreeEntity.new()] },
			{"component": "EquipmentComponent", "check":"has_weapon_equipped", "args":[]}
			],
		"fallback_intents": ["find_tree"]
	})
#
	#register_blueprint("find_tree", {
		#"preconditions": [],
		#"fallback_intents": ["wander"]  # terminal intent
	#})

static func register_blueprint(intent_name: String, blueprint: Dictionary) -> void:
	blueprints[intent_name] = blueprint

static func get_blueprint(intent_name: String) -> Dictionary:
	return blueprints.get(intent_name, {})
