class_name Statemachine extends Node

@export var initial_state: State = null

## The current state of the state machine.
@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)
).call()

#priorities of life for a worker:
# 1 : Procreate : if they are able to they will stop what they are doing to make more of themselves
# 2 : Build Shelter : if they have the materials for it, they will build shelter for themselves or their offspring
# @ : Connect homes : Build paths between shelters 
# @ : Build Port/Docks : Build a port/docks on the coast to launch a boat from
# @ : Build a Boat : Build a Boat at the Port
# @ : Build Mine : a building to collect stone from
# @ : Build Well : a building to collect water from
# @ : Collect Resources :
	# @ : Wood : from trees

func _ready() -> void:
	# Give every state a reference to the state machine.
	for child in get_children():
		if child is State:
			child.finished.connect(_transition_to_next_state)
		
	await owner.ready
	state.enter("")


func _process(delta: float) -> void:
	state.update(delta)


func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
	if not has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return

	var previous_state_path := state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
	
