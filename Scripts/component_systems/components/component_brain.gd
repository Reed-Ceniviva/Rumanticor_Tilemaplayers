extends Component
class_name BrainComponent

var memory : Dictionary = {}


func _init():
	component_name = "BrainComponent"
	super._init()

##sets the key memory equal to the value, overwrites if the memory key already exists
##
## key = string
## value = variant
## returns = void
func remember(key: String, value: Variant) -> void:
	memory[key] = value

func intent_changed(new_intent : String) -> void:
	memory["last_intent"] = memory["intent"]
	memory["intent"] = new_intent
	


##returns the value stored at memory key, takes a default value in case a return is required
##
## key = String
## default = variant
## returns = variant
func recall(key: String, default: Variant = null) -> Variant:
	return memory.get(key, default)


##erase the value stored at memory key
##
## key = string
## returns = void
func forget(key: String) -> void:
	if memory.has(key):
		memory.erase(key)
	else:
		print("no memory to forget")
		

##checks if a memory key exists in memory
##
## key = string
## returns = bool
func knows(key: String) -> bool:
	return memory.has(key)
	


##memory print function for debugging
func debug_memory():
	for key in memory.keys():
		print(key, " : ", memory[key])

func equippable_in_sight() -> bool:
	if not knows("in_sight"):
		return false
	for ent_id in recall("in_sight", []):
		var vis_ent : Entity = EntityRegistry._entity_store[ent_id]
		if vis_ent == null:
			continue
		if vis_ent.has_component_type("EquippableComponent"):
			return true
	return false

func tool_in_sight() -> bool:
	if not knows("in_sight"):
		return false
	for ent_id in recall("in_sight", []):
		var vis_ent : Entity = EntityRegistry._entity_store[ent_id]
		if vis_ent == null:
			continue
		if vis_ent.has_component_type("EquippableComponent"):
			if not vis_ent.get_component_by_type("EquippableComponent").accessory:
				return true
	return false

func tree_in_sight() -> bool:
	if not knows("in_sight"):
		return false
	for ent_id in recall("in_sight", []):
		var vis_ent : Entity = EntityRegistry._entity_store[ent_id]
		if vis_ent == null:
			continue
		if vis_ent.has_component_type("ResourceComponent"):
			if vis_ent.has_tag("tree"):
				return true
	return false
	
func log_in_sight() -> bool:
	if not knows("in_sight"):
		return false
	for ent_id in recall("in_sight", []):
		var vis_ent : Entity = EntityRegistry._entity_store[ent_id]
		if vis_ent == null:
			continue
		if vis_ent.has_component_type("ResourceComponent"):
			if vis_ent.has_tag("log"):
				return true
	return false
