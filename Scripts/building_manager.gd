extends TileMapLayer

var astar_grid : AStarGrid2D
var workers_created = 0
var roadable_tml : TileMapLayer
var roadable_qt : quad_tree_node
@onready var layer_manager = $".."

func _on_character_manager_worker_created():
	if(workers_created < 1):
		workers_created += 1
		astar_grid = AStarGrid2D.new()
		astar_grid.region = layer_manager.tm_layers["ground"].get_used_rect()
		astar_grid.cell_size = Vector2(16,16)
		astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		astar_grid.update()
		if !astar_grid.region.get_area() > 0:
			print("astar grid not defined")
		roadable_tml = layer_manager.build_traversable_tilemap(["ground"],["trees","debris"])
		roadable_qt = layer_manager.build_tml_quadtree(roadable_tml)
		for i in range(roadable_tml.position.x , roadable_tml.get_used_rect().size.x):
			for j in range(roadable_tml.position.y , roadable_tml.get_used_rect().size.y):
				var is_blocked = !roadable_qt.has(Vector2i(i,j))
				astar_grid.set_point_solid(Vector2i(i,j), is_blocked)

#returns an id_path from start to end location, adjusts start and end if they are not valid positions
func get_road_path(start_location : Vector2i, end_location : Vector2i) -> Array[Vector2i]:
	#if the start or end points are not part of the roadable tilemap
	# adjust the start and end points so that they are and return the resulting path
	#  if thats not possible return and empty array
	if not roadable_qt.has(start_location):
		if roadable_qt.has(start_location+Vector2i.RIGHT):
			start_location += Vector2i.RIGHT
		elif roadable_qt.has(start_location+Vector2i.LEFT):
			start_location += Vector2i.LEFT
		elif roadable_qt.has(start_location+Vector2i.UP):
			start_location += Vector2i.UP
		elif roadable_qt.has(start_location+Vector2i.DOWN):
			start_location += Vector2i.DOWN
		else:
			return []
	if not roadable_qt.has(end_location):
		if roadable_qt.has(end_location+Vector2i.RIGHT):
			end_location += Vector2i.RIGHT
		elif roadable_qt.has(end_location+Vector2i.LEFT):
			end_location += Vector2i.LEFT
		elif roadable_qt.has(end_location+Vector2i.UP):
			end_location += Vector2i.UP
		elif roadable_qt.has(end_location+Vector2i.DOWN):
			end_location += Vector2i.DOWN
		else:
			return []
	return astar_grid.get_id_path(start_location,end_location)
	
func get_road_path_between_buildings(start_building : building, end_building : building):
	return get_road_path(start_building.location, end_building.location)
