extends Component
class_name BrainComponent

var memory : Dictionary = {}

func _init():
	component_name = "BrainComponent"
	super._init()

func remember(key: String, value: Variant) -> void:
	memory[key] = value

func recall(key: String, default: Variant = null) -> Variant:
	return memory.get(key, default)

func forget(key: String) -> void:
	memory.erase(key)

func knows(key: String) -> bool:
	return memory.has(key)

func debug_memory():
	for key in memory.keys():
		print(key, " : ", memory[key])
