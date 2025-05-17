extends Node

var _system_sight : system_sight
var _system_movement : system_movement

func _process(delta):
	_system_movement = system_movement.new()
	_system_sight = system_sight.new()
	var worker = $entity_worker
	
	system_sight.locate_nearest_in(worker, "trees", worker.get_meta("component_sight").sight_distance)
	var target = worker.get_meta("component_sight").target_tile
	system_movement.move_to(worker, target)
