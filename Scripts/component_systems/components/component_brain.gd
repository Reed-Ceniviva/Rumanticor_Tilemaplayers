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
