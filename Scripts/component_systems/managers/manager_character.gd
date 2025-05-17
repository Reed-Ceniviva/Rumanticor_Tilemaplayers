class_name manager_character extends manager_system

var FIRST_NAMES = ["Reed", "Trevor", "George", "Lindsey", "Nick", "David", "Alexander", "Rolland", 
"Marie", "Joseph", "Gail", "Audry", "Ryan", "Cory", "Zach", "William", "James", "Jack", "Jacob",
"Bonnie", "Moo", "Dianne", "Bill", "Mario", "JD", "Jason", "Frank", "Rachel", "Cindy", "Peggy", 
"Charlene", "Charmaine", "Dave", "Davey", "Owen", "Steven", "Jamie", "Cody", "Brody", "Emma", 
"Julia", "Brendan", "Lueis", "Warner", "Hazel", "Bryce", "Mason", "Lauren", "Michele"]

@onready var world_layer_manager : layer_manager = $".."
@onready var ground : TileMapLayer = $"../Ground" 
@onready var shore : TileMapLayer = $"../Shore"
#const WORKER = preload("res://Scenes/Characters/worker.tscn")
const ENTITY_WORKER = preload("res://Scenes/Characters/ECS/Entities/entity_worker.tscn")
var astar_grid : AStarGrid2D : get = get_astar
var traversable : TileMapLayer
signal worker_created

var system_movement_instance: system_movement
var system_sight_instance: system_sight

func _ready():
	system_movement_instance = system_movement.new()
	system_movement_instance.world_layer_manager = world_layer_manager
	add_child(system_movement_instance)
	system_sight_instance = system_sight.new(world_layer_manager)
	add_child(system_sight_instance)

func _process(delta: float):
	for entity in get_tree().get_nodes_in_group("ecs_entities"):
		print(entity.get_meta_list())
		if entity.has_meta("component_sight"):
			if entity.get_meta("component_sight").target_tile != Vector2i(-1,-1):
				print("target tile: " , entity.get_meta("component_sight").target_tile)
				system_movement_instance.process_entity(entity, delta)
			else:
				system_movement_instance.move_to(entity, system_sight_instance.locate_nearest_in(entity, "trees"))

func get_first_names() -> Array:
	return FIRST_NAMES

func get_rand_name() -> String:
	return FIRST_NAMES.pick_random()

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

#should switch to using this function in layer_manager but need to figure why the commented out stuff isnt working, results in the worker not being able to see trees
# when the traversable is only used for the astargrid2d pathfinding, but trees not being valid spots means you cant navigate to them, so this should be handled where blocking is set
# for the astargrid rather than for the tilemap its built off of
func build_traversable_tilemap(traversable_layers : Array[String] = ["ground","shore"]) -> TileMapLayer:
	#different characters will be able to travers different tiles and that list will likely change if
	#say a creature learns how to swim, that one worker should be able to move in water tiles without
	#everyone else being able to yet
	#think i've decided that this is the followers level controller so all the followers having the same capabilities makes sense
	print("building traversable tilemap")
	var traversable_tilemap = TileMapLayer.new()
	var rect = ground.get_used_rect()
	#var tree_obsticles = world_layer_manager.tm_layers["trees"].get_used_cells()
	for layer_name in traversable_layers:
		var layer : TileMapLayer = world_layer_manager.tm_layers[layer_name]
		for y in range(rect.position.y, rect.position.y + rect.size.y):
			for x in range(rect.position.x, rect.position.x + rect.size.x):
				var pos_check = Vector2i(x,y)
				#var is_obsticle = tree_obsticles.has(pos_check)
				if layer.get_cell_tile_data(pos_check) != null : #and not is_obsticle
					traversable_tilemap.set_cell(
					pos_check,
					layer.get_cell_source_id(pos_check),
					layer.get_cell_atlas_coords(pos_check),
					layer.get_cell_alternative_tile(pos_check)
				)
	return traversable_tilemap

#i guess since blocking all trees would mean that you cant path towards them
# the debris can be blocked, really the path should be a straight shot and then the worker adjusting the path as obsticals are encountered
func _on_worker_created(): #prepare pathfinding 
	print("worker created")
	if(astar_grid == null):
		astar_grid = AStarGrid2D.new()
		astar_grid.region = ground.get_used_rect()
		astar_grid.cell_size = Vector2(16,16)
		astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		astar_grid.update()
		if !astar_grid.region.get_area() > 0:
			print("astar grid not defined")
		var traversable_tml = world_layer_manager.build_traversable_tilemap()
		var traversable_qt = world_layer_manager.build_tml_quadtree(traversable_tml)
		for i in range(traversable_tml.position.x , ground.get_used_rect().size.x):
			for j in range(traversable_tml.position.y , ground.get_used_rect().size.y):
				var is_blocked = !traversable_qt.has(Vector2i(i,j))
				astar_grid.set_point_solid(Vector2i(i,j), is_blocked)
		system_movement_instance.astar_grid = astar_grid

#func generate_char_stats(entity : entity_worker):
	

func _on_layer_manager_world_created():
		print("creating initial worker")
		var new_entity_worker = ENTITY_WORKER.instantiate() # will add itself as a child of this node
		new_entity_worker.setup(world_layer_manager)
		#var new_worker = WORKER.instantiate()
		add_child(new_entity_worker)
		new_entity_worker.position = ground.map_to_local(find_ground())
		worker_created.emit()
