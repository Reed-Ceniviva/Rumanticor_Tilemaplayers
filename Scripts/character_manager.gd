class_name character_manager extends Node

@onready var world_layer_manager : layer_manager = $".."
@onready var ground : TileMapLayer = $"../Ground" 
@onready var shore : TileMapLayer = $"../Shore"
const WORKER = preload("res://Scenes/Characters/worker.tscn")
var trees_created = 0
var workers_created = 0
var astar_grid : AStarGrid2D : get = get_astar
var traversable : TileMapLayer
signal worker_created
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func find_ground() -> Vector2i:
	print("finding ground")
	var valid_pos = Vector2i(-1,-1)
	for i in range(world_layer_manager.world_x):
		for j in range(world_layer_manager.world_y):
			if ground.get_cell_atlas_coords(Vector2i(i,j)) != Vector2i(-1,-1):
				valid_pos = Vector2i(i,j)
				print(valid_pos)
				return valid_pos
	print("valid spot not found")
	return Vector2i(-1,-1)

func get_astar():
	return astar_grid

#instantiates the first worker once the tilemaps are queryable 
func _on_layer_manager_quadtree_created():
	print("quadtree created")
	trees_created += 1
	print(trees_created)
	if trees_created == 3: # all quadtrees created
		print("creating initial worker")
		var new_worker = WORKER.instantiate()
		new_worker.position = ground.map_to_local(find_ground())
		add_child(new_worker)
		worker_created.emit()

#this is fucking horrible
func build_traversable_tilemap(traversable_layers : Array[String] = ["Ground","Shore"]) -> TileMapLayer:
	#different characters will be able to travers different tiles and that list will likely change if
	#say a creature learns how to swim, that one worker should be able to move in water tiles without
	#everyone else being able to yet
	print("building traversable tilemap")
	var traversable_tilemap = TileMapLayer.new()
	var rect = ground.get_used_rect()
	for y in range(rect.position.y, rect.position.y + rect.size.y):
		for x in range(rect.position.x, rect.position.x + rect.size.x):
			var pos_check = Vector2i(x,y)
			for layer_name in traversable_layers:
				var layer : TileMapLayer = get_node(("../".insert(3, layer_name) ))
				if layer.get_cell_tile_data(pos_check) != null:
					traversable_tilemap.set_cell(
					pos_check,
					layer.get_cell_source_id(pos_check),
					layer.get_cell_atlas_coords(pos_check),
					layer.get_cell_alternative_tile(pos_check)
				)
	return traversable_tilemap

func _on_worker_created(): #prepare pathfinding 
	print("worker created")
	if(workers_created < 1):
		workers_created += 1
		astar_grid = AStarGrid2D.new()
		astar_grid.region = ground.get_used_rect()
		astar_grid.cell_size = Vector2(16,16)
		astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		astar_grid.update()
		if !astar_grid.region.get_area() > 0:
			print("astar grid not defined")
		var traversable_tml = build_traversable_tilemap()
		var traversable_qt = world_layer_manager.build_tml_quadtree(traversable_tml)
		for i in range(traversable_tml.position.x , ground.get_used_rect().size.x):
			for j in range(traversable_tml.position.y , ground.get_used_rect().size.y):
				var is_blocked = !traversable_qt.has(Vector2i(i,j))
				astar_grid.set_point_solid(Vector2i(i,j), is_blocked)
