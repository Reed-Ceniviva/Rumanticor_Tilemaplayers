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
var father : bool = false

#enum {IDLE, WALKING, MAKING, GETTING, WONDER}

const WORKER = preload("res://Scenes/Characters/worker.tscn")
@onready var world_character_manager : character_manager = $".."
@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D
@onready var world_layer_manager : layer_manager = $"../.."

#var astar_grid : AStarGrid2D
var current_id_path : Array[Vector2i]
var walking : bool = false
var tasks : Array[int]

var inventory : Dictionary

var map_location : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	tasks.append(1)
	inventory["wood"] = 0

func _physics_process(delta):
	time += delta
	if health > 0 and time > nextmove and tasks.size() > 0: #while worker is alive and there is something to do
		nextmove = movedelay + time
		print("Tasks ID: " , tasks[0])
		print("Logs: ", inventory["wood"])
		if(current_id_path.size() > 0):
			position = world_layer_manager.tm_layers["ground"].map_to_local(current_id_path.front())
			current_id_path = current_id_path.slice(1)
		if(tasks[0] == 1):#blindly move ~ idle
			if (inventory["wood"] >= 5):#if you have enough wood to build a hut, build a hut
				build_hut()
			elif (locate_hut() != null and time > 30 and !father): # if this worker is ready to be a father and is near a hut
				tasks.clear()
				tasks.append(4)
			else:
				if locate_tree(): # if while moving around randomly you see a tree, move to that tree
					tasks.clear()
					tasks.append(2)
				else:
					tasks.clear()
					tasks.append(1)
					blindly_move()
		elif(tasks[0] == 2): 	#move to tree
			if move_to_tree(): # if there is a tree in sight
				tasks.clear()
				tasks.append(3)
			else: # if no tree in sight move around randomly
				tasks.clear()
				tasks.append(1)
		elif(tasks[0] == 3): #chop Tree
			if locate_tree(1): #while a tree is 1 cell away
				chop_tree()
				tasks.clear() #move randomly looking for a tree after chopping
				tasks.append(1)
			elif current_id_path.size() == 0: # if we are done moving and there is no tree around cancel chopping the tree and walk blindly
				print("arrived to no tree")
				tasks.clear()
				tasks.append(1)
		elif(tasks[0] == 4): #reproduce
			if(make_baby()):
				father = true
				tasks.clear()
				tasks.append(2)
			elif current_id_path.size() == 0:
				print("arrived to no hut")
				tasks.clear()
				tasks.append(1)
				
		else:				#idle
			pass

func blindly_move(): # State 1
	animated_sprite_2d.play("default")
	var surroundings : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("ground", map_location, 1)
	for i in range(surroundings.size()):
		if surroundings[i] == map_location:
			surroundings.remove_at(i)
			break
	if surroundings.size() > 0:
		current_id_path.clear()
		var random_pick = randi()%surroundings.size()
		move_to(surroundings[random_pick], true)
	else:
		print("nowhere to move")
			
#func directional_move(direction : int):
	
func move_to(target_pos : Vector2i, enter : bool = false): # sets the current ID path to arrive at a neighboring tile of target_pos
	current_id_path.clear()
	animated_sprite_2d.play("default")
	var start_pos = map_location
	
	var id_path = world_character_manager.astar_grid.get_id_path(start_pos, target_pos).slice(1)
	if !enter: #exclude last position as not to enter the destination
		id_path = id_path.slice(0,id_path.size()-1)
	
	if id_path.is_empty() == false:
		current_id_path = id_path
	else:
		print("trying to move to current location")

#func look_around(target_qt):

func locate_tree(distance : int = sight_distance):
	#var tree_qt = world_layer_manager.get_tree_qt()
	var surroundings : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("trees", map_location, distance)
	if surroundings.size() > 0:
		return get_closest_point(map_location, surroundings)
	else:
		return null
	
#should combine state 2 and 3 so that it works like state 4    
func move_to_tree(): # state 2
	current_id_path.clear()
	var nearby_tree = locate_tree()
	if nearby_tree != null:
		move_to(nearby_tree)
		return true
	else:
		print("no tree in sight")
		return false

func chop_tree(): #state 3
	if locate_tree(1) != null:
		animated_sprite_2d.play("chop")
		world_layer_manager.tree_chopped(locate_tree(1))
		inventory["wood"] = inventory["wood"] + 1
		return true
	else:
		print("no tree to chop")
		return false
		
func build_hut():
	print("building hut")
	var surroundings : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("ground", map_location, 1)
	for i in surroundings:
		if i != map_location and world_layer_manager.tm_layers["buildings"].get_cell_atlas_coords(i) == Vector2i(-1,-1):
			animated_sprite_2d.play("chop")
			world_layer_manager.hut_built(i)
			inventory["wood"] = inventory["wood"] - 5
			return i         
  
func locate_hut(distance : int = sight_distance):
	var local_huts : Array[Vector2i] = world_layer_manager.get_non_empty_cells_in_radius("buildings", map_location, distance)
	if local_huts.size() > 0 :
		return get_closest_point(map_location, local_huts)
	else:
		return null     
	
func move_to_hut():
	var nearby_hut = locate_hut()
	if nearby_hut != null:
		move_to(nearby_hut, true)
		return true
	else:
		print("no hut in sight")
		return false

func make_baby(): #state 4
	print("baking baby")
	var building_cells = world_layer_manager.tm_layers["buildings"].get_used_cells()
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

func get_closest_point(target: Vector2i, points: Array[Vector2i]) -> Vector2i:
	if points.has(target):
		for i in range(points.size()):
			if points[i] == target:
				points.remove_at(i)
				break
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
