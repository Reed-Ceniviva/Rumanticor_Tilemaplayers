class_name character_manager extends Node

var FIRST_NAMES = ["Reed", "Trevor", "George", "Lindsey", "Nick", "David", "Alexander", "Rolland", 
"Marie", "Joseph", "Gail", "Audry", "Ryan", "Cory", "Zach", "William", "James", "Jack", "Jacob",
"Bonnie", "Moo", "Dianne", "Bill", "Mario", "JD", "Jason", "Frank", "Rachel", "Cindy", "Peggy", 
"Charlene", "Charmaine", "Dave", "Davey", "Owen", "Steven", "Jamie", "Cody", "Brody", "Emma", 
"Julia", "Brendan", "Lueis", "Warner", "Hazel", "Bryce", "Mason", "Lauren", "Michele"]

@onready var world_layer_manager : layer_manager = $".."
@onready var ground : TileMapLayer = $"../Ground" 
@onready var shore : TileMapLayer = $"../Shore"
const WORKER = preload("res://Scenes/Characters/worker.tscn")
var astar_grid : AStarGrid2D : get = get_astar
var traversable : TileMapLayer
signal worker_created
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_first_names() -> Array:
	return FIRST_NAMES

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


func _on_layer_manager_world_created():
		print("creating initial worker")
		var new_worker = WORKER.instantiate()
		new_worker.position = ground.map_to_local(find_ground())
		add_child(new_worker)
		worker_created.emit()

func upgrade_to_employed() -> Node:
	var new_worker = preload("res://Scenes/Characters/employed_worker.tscn").instantiate()
	
	# Transfer important data
	new_worker.health = self.health
	new_worker.sex = self.sex
	new_worker.char_name = self.char_name
	new_worker.strength = self.strength
	new_worker.age = self.age
	new_worker.time = self.time
	new_worker.movedelay = self.movedelay
	new_worker.sight_distance = self.sight_distance
	new_worker.last_birth = self.last_birth
	new_worker.birth_delay = self.birth_delay
	new_worker.wander_start = self.wander_start
	new_worker.wander_dir = self.wander_dir
	new_worker.wander_delay = self.wander_delay
	
	new_worker.current_id_path = self.current_id_path.duplicate()
	new_worker.walking = self.walking
	new_worker.destination = self.destination
	new_worker.home = self.home
	new_worker.inventory = self.inventory.duplicate()
	new_worker.map_location = self.map_location
	
	# Transfer offspring
	for child in self.offspring:
		new_worker.offspring.append(child)
	
	# Transfer position in scene
	new_worker.position = self.position
	new_worker.rotation = self.rotation
	new_worker.scale = self.scale
	
	# Attach to scene and replace
	var parent = self.get_parent()
	var index = self.get_index()
	parent.remove_child(self)
	parent.add_child(new_worker)
	parent.move_child(new_worker, index)
	
	self.queue_free()
	
	return new_worker
