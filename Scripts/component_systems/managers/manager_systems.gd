extends Node
class_name manager_systems

var systems : Array = []

func _ready():
	# Register all systems you want to use here
	systems.append(system_health.new())
	#systems.append(WanderSystem.new())
	systems.append(system_movement.new())

func update_all(workers : Array, delta : float):
	for system in systems:
		for worker in workers:
			system.update(worker, delta)
