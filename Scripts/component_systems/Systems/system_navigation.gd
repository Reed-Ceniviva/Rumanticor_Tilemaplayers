extends System
class_name NavigationSystem

@export var terrain_map: Dictionary = {}

func _init():
	required_components = ["PositionComponent", "MobilityComponent", "MovementPathComponent", "TargetEntityComponent", "CurrentGoalComponent"]

# Used to get neighbors (4-way)
const DIRS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

func process_entity(entity: Entity) -> void:
	
	print("computing navigation")
	if not entity.has_component_type("PositionComponent"): return
	if not entity.has_component_type("BrainComponent"): return
	#if not entity.has_component_type("TargetEntityComponent"): return

	var start = entity.get_component_by_type("PositionComponent").pos
	var goal_id = entity.get_component_by_type("BrainComponent").recall("target", -1)
	
	if goal_id == -1:
		return
	
	var goal_pos = EntityRegistry._entity_store[goal_id].get_component_by_type("PositionComponent").pos
	var mobility = entity.get_component_by_type("BrainComponent").recall("traverses", [])

	var path := _find_path(start, goal_pos, mobility)
	entity.get_component_by_type("BrainComponent").remember("current_path", path)




func _find_path(start: Vector2i, goal: Vector2i, mobility: Dictionary) -> Array[Vector2i]:
	var open_set := [start]
	var came_from := {}
	var g_score := {start: 0.0}
	var f_score := {start: start.distance_to(goal)}

	while open_set.size() > 0:
		open_set.sort_custom(func(a, b): return f_score.get(a, INF) < f_score.get(b, INF))
		var current = open_set[0]

		if current == goal:
			return _reconstruct_path(came_from, current)

		open_set.remove_at(0)

		for dir in DIRS:
			var neighbor = current + dir
			if not terrain_map.has(neighbor):
				continue

			var layers = terrain_map[neighbor]
			var cost := _get_tile_cost(layers, mobility)
			if cost == INF:
				continue  # Unwalkable

			var tentative_g_score = g_score.get(current, INF) + cost
			if tentative_g_score < g_score.get(neighbor, INF):
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = tentative_g_score + neighbor.distance_to(goal)
				if not neighbor in open_set:
					open_set.append(neighbor)

	return []  # No path found


func _get_tile_cost(layers: Array[String], mobility: Dictionary) -> float:
	var total := 0.0
	var valid := false
	for layer in layers:
		if layer == "ground" or layer == "shore" or layer == "beach":
			if mobility.has("ground"):
				total += 1.0 / max(mobility[layer], 0.01)  # Avoid divide-by-zero
				valid = true
		if layer == "water":
			if mobility.has(layer):
				total += 1.0 / max(mobility[layer], 0.01)
				valid = true
		else:
			if mobility.has("air"):
				total += 1.0 / max(mobility[layer], 0.01)
				valid = true
	return total if valid else INF


func _reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var path := [current]
	while came_from.has(current):
		current = came_from[current]
		path.insert(0,current)
	return path
