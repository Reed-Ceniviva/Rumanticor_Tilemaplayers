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
var father : int = 0
var last_birth = 0
var birth_delay = 18
var wander_start = 0
var wander_dir = -1
var wander_delay = 10

#enum {IDLE, WALKING, MAKING, GETTING, WONDER}

const WORKER = preload("res://Scenes/Characters/worker.tscn")
@onready var world_character_manager : character_manager = $".."
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var world_layer_manager : layer_manager = $"../.."

#var astar_grid : AStarGrid2D
var current_id_path : Array[Vector2i]
var walking : bool = false
var destination : Vector2i
var home_location : Vector2i

var inventory : Dictionary

var map_location : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory["wood"] = 0
	birth_delay = randi()%(18-2) + 2
	home_location = Vector2i.ZERO

#get rid of tasks till a real task system is needed
#clean up code to use the new move to function
#watch out for places where im calling functions over and over rather than just stepping forward through the process simply
func _physics_process(delta):
	time += delta
	age = time
	if health > 0 and time > nextmove: #while worker is alive and there is something to do
		nextmove = movedelay + time
		print("Wood Logs: ", inventory["wood"])
		print("Current Path:", current_id_path)
		if(current_id_path.size() > 0): # if we were moving somewhere, continue moving there
			position = world_layer_manager.tm_layers["ground"].map_to_local(current_id_path.front())
			current_id_path = current_id_path.slice(1)
			
		if(inventory["wood"] >= 5 and home_location != Vector2i.ZERO):#build a hut
			if build_hut():
				home_location = destination
			else:
				wander()
		elif(father <= 5 and home_location != Vector2i.ZERO and age > 18 and age >= last_birth+birth_delay): #reproduce
			if current_id_path.is_empty():
				if locate_hut(1):
					reproduce()
					last_birth = age
				else:
					move_to(home_location)
		elif(inventory["wood"] < 5): #Collect more wood
			if current_id_path.is_empty():
				if locate_tree(1):
					chop_tree()
				else:
					if ! move_to_tree():
						wander()
			
		#if(tasks[0] == 1):#blindly move ~ idle : if other priorities are met
			#if (inventory["wood"] >= 5):#if you have enough wood to build a hut, build a hut
				#build_hut()
			#elif (locate_hut() != false and time > 30 and !father): # if this worker is ready to be a father and is near a hut
				#tasks.remove_at(0)
				#tasks.append(4)
			#else:
				#if locate_tree(): # if while moving around randomly you see a tree, move to that tree
					#tasks.remove_at(0)
					#tasks.append(2)
				#else:
					#blindly_move()
		#elif(tasks[0] == 2): 	#move to tree 
			#if locate_tree(): # if there is a tree in sight
				#move_to(destination)
				#tasks.remove_at(0)
				#tasks.append(3)
			#else: # if no tree in sight move around randomly
				#tasks.remove_at(0)
				#tasks.append(1)
		#elif(tasks[0] == 3): #chop Tree
			#if locate_tree(1): #when a tree is 1 cell away
				#chop_tree()
				#tasks.remove_at(0) #move randomly looking for a tree after chopping
				#tasks.append(1)
			#elif current_id_path.size() == 0: # if we are done moving and there is no tree around cancel chopping the tree and walk blindly
				#print("arrived to no tree")
				#tasks.clear()
				#tasks.append(1)
		#elif(tasks[0] == 4): #reproduce
			#if(make_baby()):
				#father = true
				#tasks.clear()
				#tasks.append(2)
			#elif current_id_path.size() == 0:
				#print("arrived to no hut")
				#tasks.clear()
				#tasks.append(1)
		#else:				#idle
			#tasks[0] = 1

func wander():
	if wander_start+wander_delay < time:
		wander_dir = randi()%4
		wander_start = time
	blindly_move(wander_dir)

##Moving Functions : Functions that access the current id path
func blindly_move(direction : int = -1): # State 1
	print("blindly move called")
	animated_sprite_2d.play("default")
	var surroundings : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("ground", map_location, 1)
	surroundings.erase(map_location)
	if surroundings.size() > 0:
		if direction == -1 or surroundings.size()-1 < (direction): # if there is no given direction or the character is unable to move in that direction
			var random_pick : Vector2i = surroundings[randi()%surroundings.size()-1]
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
func move_to(target_pos : Vector2i, enter : bool = false): # sets the current ID path to arrive at a neighboring tile of target_pos
	current_id_path.clear()
	animated_sprite_2d.play("default")
	var start_pos = map_location
	var id_path = world_character_manager.astar_grid.get_id_path(start_pos, target_pos).slice(1) #remove starting pos from path
	if !enter: #exclude last position as not to enter the destination
		id_path = id_path.slice(0,id_path.size()-1)
	
	if id_path.is_empty() == false:
		current_id_path = id_path
	else:
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
		print("no tree in sight")
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
		print("no hut is sight")
		return false     
	
#might be a pointless function
#calls locate hut and if successful calls move_to on distination with enter=true
#returns false if locate hut returns false
func move_to_hut() -> bool:
	if locate_hut():
		move_to(destination, true)
		return true
	else:
		print("no hut in sight")
		return false

func reproduce():
	var new_worker = WORKER.instantiate()
	var to_the_right = Vector2i(1,0)
	new_worker.position = world_layer_manager.tm_layers["ground"].map_to_local(map_location + to_the_right)
	get_parent().add_child(new_worker)
	father += 1
	return true

#this needs to be rewritten
func make_baby(): #state 4
	print("baking baby")
	var building_cells = world_layer_manager.tm_layers["buildings"].get_used_cells()
	world_layer_manager.get_non_empty_cells_in_radius("buildings", map_location, 1)
	if building_cells.has(map_location): #if worker has arrived to a building
		var new_worker = WORKER.instantiate()
		var to_the_right = Vector2i(1,0)
		new_worker.position = world_layer_manager.tm_layers["ground"].map_to_local(map_location + to_the_right)
		get_parent().add_child(new_worker)
		return true
	elif current_id_path.is_empty():
		move_to_hut()
	elif building_cells.has(current_id_path.back()):
		#on the way to the hut
		pass
	else:
		move_to_hut()
		return false

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
