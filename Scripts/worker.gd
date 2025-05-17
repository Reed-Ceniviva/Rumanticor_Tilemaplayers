class_name worker extends Node2D


var health : float = 100.0 : get = get_health, set = set_health
var sex : bool = true : get = get_sex, set = set_sex# male | false = female
var char_name : String = "John" : get = get_char_name , set = set_char_name
var strength : float = 10 : get = get_strength, set = set_strength
var age : float = 0.0 : get = get_age, set = set_age
var time = 0.0
@export var movedelay = 0.25
var nextmove = 0.0
var sight_distance = 32
var offspring : Array[worker]
var last_birth = 0
var birth_delay = 18
var wander_start = 0
var wander_dir = -1
var wander_delay = 10

#enum {IDLE, WALKING, MAKING, GETTING, WONDER}

const WORKER = preload("res://Scenes/Characters/worker.tscn")
@onready var world_character_manager : manager_character = $".."
@onready var animated_sprite_2d : AnimatedSprite2D = self.get_child(0)
@onready var world_layer_manager : layer_manager = $"../.."

#var astar_grid : AStarGrid2D
var current_id_path : Array[Vector2i]
var walking : bool = false
var destination : Vector2i
var home : building

var inventory : Dictionary

var map_location : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory["wood"] = 0
	birth_delay = randi()%(18-2) + 2
	var names = world_character_manager.get_first_names()
	var names_size = names.size()
	set_char_name(names[randi()%names_size])
	set_sex(randi()%2)

#get rid of tasks till a real task system is needed
#clean up code to use the new move to function
#watch out for places where im calling functions over and over rather than just stepping forward through the process simply
func _physics_process(delta):
	pass_time(delta)
	worker_life()

func pass_time(delta):
	time += delta
	age = time

func worker_life():
	if health > 0 and time > nextmove: #while worker is alive and there is something to do
		nextmove = movedelay + time
		#print("Wood Logs: ", inventory["wood"])
		#print("Current Path:", current_id_path)
		if(current_id_path.size() > 0): # if we were moving somewhere, continue moving there
			position = world_layer_manager.tm_layers["ground"].map_to_local(current_id_path.front())
			current_id_path = current_id_path.slice(1)
			
		if(inventory["wood"] >= 5 and home == null):#build a hut
			if build_hut():
				home = building.new(destination)
			else:
				wander()
		elif(offspring.size() < 3 and home != null and age > 18 and age >= last_birth+birth_delay): #reproduce
			if current_id_path.is_empty():
				if locate_hut(1):
					reproduce()
					last_birth = age
				else:
					if move_to(home.location) == false:
						wander()
		elif(home != null and home.get_inventory("wood") < home.max_inventory and inventory["wood"] > 0):
			if locate_hut(1):
				inventory["wood"] = home.insert_inventory("wood",inventory["wood"])
			if move_to(home.location) == false:
				wander()
		elif(inventory["wood"] < 5): #Collect more wood
			if current_id_path.is_empty():
				if locate_tree(1):
					chop_tree()
				else:
					if ! move_to_tree():
						wander()
		else:
			wander()
#controlled blindly moving
func wander():
	#print("wandering")
	if wander_start+wander_delay < time:
		wander_dir = randi()%4
		wander_start = time
	blindly_move(wander_dir)

##Moving Functions : Functions that access the current id path
func blindly_move(direction : int = -1): # State 1
	#print("blindly move called")
	animated_sprite_2d.play("default")
	var surroundings : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("ground", map_location, 1)
	surroundings.erase(map_location)
	if surroundings.size() > 0:
		if direction == -1 or surroundings.size()-1 < (direction): # if there is no given direction or the character is unable to move in that direction
			print("invalid move")
			pass
			var random_pick : Vector2i = surroundings[0]
			move_to(random_pick, true)
		else:
			move_to(surroundings[direction],true)
	else:
		print("nowhere to move")
			
#func directional_move(direction : int):
	
#sets the current id path equal to an array of vector2i locations making up a valid path to target pos
#uses the character manager astargrid2d for path generation
#takes an optional variable enter(bool) for whether to include the target pos in the path
#returns void
func move_to(target_pos : Vector2i, enter : bool = false) -> bool: # sets the current ID path to arrive at a neighboring tile of target_pos
	current_id_path.clear()
	animated_sprite_2d.play("default")
	var start_pos = map_location
	var id_path = world_character_manager.astar_grid.get_id_path(start_pos, target_pos).slice(1) #remove starting pos from path
	if !enter: #exclude last position as not to enter the destination
		id_path = id_path.slice(0,id_path.size()-1)
	
	if id_path.is_empty() == false:
		current_id_path = id_path
		return true
	else:
		return false
		print("trying to move to current location")

#func look_around(target_qt):

#finds a non-empty tree tile in radius distance from the worker
#sets destination equal to the closest tree
#returns true if a tree is in radius distance from the worker
#returns false otherwise
func locate_tree(distance : int = sight_distance) -> bool:
	#var tree_qt = world_layer_manager.get_tree_qt()
	var surroundings : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("trees", map_location, distance)
	surroundings.erase(map_location)
	if surroundings.size() > 0:
		destination = get_closest_point(map_location, surroundings)
		return true
	else:
		#print("no tree in sight")
		return false
	

#function using functions
#if locate tree returns true calls move_to on destination
#returns true if locate tree returns true
#returns false otherwise  
func move_to_tree() -> bool: # state 2
	if locate_tree():
		move_to(destination)
		return true
	else:
		return false

#if there is a tree adjacent to the worker, it plays the chop animation, handles changing the tilemap data, and adjusts inventory
#returns true if there is a tree to chop
#returns false if there is no adjacent tree
func chop_tree() -> bool: #state 3
	if locate_tree(1):
		animated_sprite_2d.play("chop")
		world_layer_manager.tree_chopped(destination)
		inventory["wood"] = inventory["wood"] + 1
		return true
	else:
		print("no tree to chop")
		return false
		
#picks a random spot around the worker that does not contain a building and builds a hut
#sets destination equal to where the hut is built
#returns true if a hut is built on a valid spot,
#returns false if no valid spot is found
func build_hut() -> bool:
	print("building hut")
	var surroundings : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("ground", map_location, 1)
	for i in surroundings:
		if i != map_location and world_layer_manager.tm_layers["buildings"].get_cell_atlas_coords(i) == Vector2i(-1,-1):
			destination = i
			animated_sprite_2d.play("chop")
			world_layer_manager.hut_built(i)
			inventory["wood"] = inventory["wood"] - 5
			return true    
	print("nowhere to build hut")
	return false     

#checks for a non-empty building tile in radius of distance from map-location, defualts to sight_distance
#returns true if there is a hut in radius distance and sets destination equal to the closest location
#returns false if no hut is in radius distance
func locate_hut(distance : int = sight_distance) -> bool:
	var local_huts : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("buildings", map_location, distance)
	if local_huts.size() > 0 :
		destination = get_closest_point(map_location, local_huts)
		return true
	else:
		#print("no hut in sight")
		return false     
	

func locate_nearest_in(layer_name : String, distance : int = sight_distance) -> bool:
	var local_locations : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius(layer_name, map_location, distance)
	if local_locations.size() > 0 :
		destination = get_closest_point(map_location, local_locations)
		return true
	else:
		print("no non-empty tile in " , layer_name , " within distance: " , distance)
		return false 

#might be a pointless function
#calls locate hut and if successful calls move_to on distination with enter=true
#returns false if locate hut returns false
func move_to_hut() -> bool:
	if locate_hut():
		move_to(destination, true)
		return true
	else:
		return false

#creates new worker and adds them to this workers offspring
func reproduce():
	var new_worker = WORKER.instantiate()
	var to_the_right = Vector2i(1,0)
	new_worker.position = world_layer_manager.tm_layers["ground"].map_to_local(map_location + to_the_right)
	get_parent().add_child(new_worker)
	offspring.append(new_worker)
	birth_delay = randi()%(18-2) + 2
	return true

func get_extended_offspring_mine() -> Array[worker]:
	var all_offspring : Array[worker]
	for child in offspring:
		all_offspring.append(child)
		all_offspring += child.get_extended_offspring()
	return all_offspring

func get_extended_offspring(visited : Dictionary = {}) -> Array:
	var all_offspring = []
	
	for child in offspring:
		if child == self:
			continue  # Prevent self-reference (extreme safety)
		if child in visited:
			continue  # Already visited, skip to prevent duplicates or circular loops
		visited[child] = true  # Mark as visited
		all_offspring.append(child)
		all_offspring += child.get_extended_offspring(visited)  # Recurse
	
	return all_offspring

#takes a Vector2i position and and Array of Vector2i and returns the closest point in the array to the target
# if the array is empty or only contains the target location, returns the target location
func get_closest_point(target: Vector2i, points: Array[Vector2i]) -> Vector2i:
	if points.has(target):
		points.erase(target)
	if points.size() > 0:
		var closest = points[0]
		var min_dist_sq = target.distance_squared_to(closest)
		for point in points:
			var dist_sq = target.distance_squared_to(point)
			if dist_sq < min_dist_sq:
				min_dist_sq = dist_sq
				closest = point
		return closest
	else:
		print("no closest point, returning starting position")
		return target
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	map_location = world_layer_manager.tm_layers["ground"].local_to_map(position)

func get_age():
	return age
	
func set_age(new_age):
	age = new_age

func get_strength():
	return strength
	
func set_strength(new_strength):
	strength = new_strength

func get_char_name():
	return char_name
	
func set_char_name(new_name):
	char_name = new_name

func set_health(new_health):
	health-= new_health
	
func get_health():
	return health

func get_sex():
	return sex
	
func set_sex(new_sex):
	sex = new_sex
