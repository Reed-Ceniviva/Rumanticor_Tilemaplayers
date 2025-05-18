extends Resource
class_name component_sight

@export var sight_distance: int = 32
var target_tile: Vector2i = Vector2i(-1,-1)

func setup(sight: int = 32):
	sight_distance = sight

## Finds the closest point in an array to a reference position
## @param origin The point of reference
## @param points An array of Vector2i positions to compare
## @returns The closest Vector2i in `points` to `origin`
func get_closest_point(origin: Vector2i, points: Array[Vector2i]) -> Vector2i:
	var closest = Vector2i(-1, -1)
	var shortest_distance = INF
	for point in points:
		var distance = origin.distance_to(point)
		if distance < shortest_distance:
			shortest_distance = distance
			closest = point
	return closest
