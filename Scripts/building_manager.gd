extends TileMapLayer

var astar_grid : AStarGrid2D
var workers_created = 0
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
		var traversable_tml : TileMapLayer = layer_manager.build_traversable_tilemap(["ground"],["trees","debris"])
		var traversable_qt = layer_manager.build_tml_quadtree(traversable_tml)
		for i in range(traversable_tml.position.x , traversable_tml.get_used_rect().size.x):
			for j in range(traversable_tml.position.y , traversable_tml.get_used_rect().size.y):
				var is_blocked = !traversable_qt.has(Vector2i(i,j))
				astar_grid.set_point_solid(Vector2i(i,j), is_blocked)
