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

#create needed tasks for workers
var locate_tree = task_locate_tree.new()
var move_to = task_move_to_target.new()
var chop_tree = task_chop_tree.new()
var build_hut = task_build_hut.new()
var locate_building_location = task_locate_building_location.new()
var go_home = task_go_home.new()
var reproduce = task_worker_reproduce.new()
var store_wood = task_store_wood.new()

func _ready():
	#create and add movement system
	system_movement_instance = system_movement.new()
	system_movement_instance.world_layer_manager = world_layer_manager
	add_child(system_movement_instance)
	#create and add sight system
	system_sight_instance = system_sight.new(world_layer_manager)
	add_child(system_sight_instance)
	move_to.setup(system_movement_instance)
	go_home.setup(system_movement_instance)
	

func _process(delta: float):
	#print(get_tree().get_nodes_in_group("ecs_entities"))
	for entity in get_tree().get_nodes_in_group("ecs_entities"):
		#print(entity.get_meta_list())
		
		if not entity.has_meta("component_charstats"):
			continue
		
		var stats : component_charstats = entity.get_meta("component_charstats")
		if stats == null:
			continue
		#returns until the worker is able to take an action again
		stats.next_action_time -= delta
		if stats.next_action_time > 0:
			continue
		stats.next_action_time = stats.action_delay
		
		if entity.has_meta("component_inventory") and entity.has_meta("component_tasks") and entity.has_meta("component_family"):
			var entity_inventory : component_inventory = entity.get_meta("component_inventory")
			var entity_tasks : component_tasks = entity.get_meta("component_tasks")
			var entity_family : component_family = entity.get_meta("component_family")
			print("ecs_entities: " , get_tree().get_nodes_in_group("ecs_entities"))
			print("worker: " , stats.char_name, " | ", entity_tasks.task_queue.size(), " | ")
			if entity_tasks.task_queue.size() > 0:
				print("task type: " ,entity_tasks.task_queue[0].task_type)
			print("current path: " , entity.get_meta("component_movement").current_id_path)
			print("action delay: " , entity.get_meta("component_charstats").action_delay, " | next action time: " , entity.get_meta("component_charstats").next_action_time)
			if entity_tasks.task_queue.size() == 0 and entity.get_meta("component_movement").current_id_path.size() == 0:
				#print(entity_inventory.get_item_count("wood"))
				if entity_inventory.get_item_count("wood") >= entity_inventory.max_capacity:
					if  entity_family.home == Vector2i(-1,-1):
						build_home(entity)
					else:
						store_wood_at_home(entity)
				else:
					if  entity_family.home != Vector2i(-1,-1):
						if world_layer_manager.building_data.get_cell_data(entity_family.home).get_or_add("wood",0) >= 5 and entity_family.offspring.size() < 1:
							start_family(entity)
						else:
							collect_wood(entity)
					else:
						collect_wood(entity)
			else:
				entity.get_meta("component_tasks").update(entity)
				entity.get_meta("component_tasks").process_tasks(entity)
		if entity.has_meta("component_movement"):
			system_movement_instance.process_entity(entity, delta)

func collect_wood(entity : entity_worker):
	if entity.has_meta("component_tasks"):
		entity.get_meta("component_tasks").task_queue.append_array([locate_tree, move_to, chop_tree])
	#entity.get_meta("component_tasks").task_queue.append_array([locate_tree])
	#entity.get_meta("component_tasks").task_queue.append_array([move_to])
	#entity.get_meta("component_tasks").task_queue.append_array([chop_tree])

func build_home(entity : entity_worker):
	if entity.has_meta("component_tasks"):
		entity.get_meta("component_tasks").task_queue.append_array([locate_building_location, build_hut])

func start_family(entity : entity_worker):
	if entity.has_meta("component_tasks"):
		entity.get_meta("component_tasks").task_queue.append_array([go_home,reproduce])
	
func store_wood_at_home(entity : entity_worker):
		if entity.has_meta("component_tasks"):
			entity.get_meta("component_tasks").task_queue.append_array([go_home,store_wood])
	
	
	
func get_first_names() -> Array:
	return FIRST_NAMES

func get_rand_name() -> String:
	return FIRST_NAMES.pick_random()

func process_tasks(entity : entity_worker):
	var tasks = entity.get_meta("component_tasks")
	if tasks.current_task:
		tasks.update(entity)
	elif tasks.task_queue.size() > 0:
		tasks.start_next_task(entity)

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


#i guess since blocking all trees would mean that you cant path towards them
# the debris can be blocked, really the path should be a straight shot and then the worker adjusting the path as obsticals are encountered
func _on_worker_created(): # Prepare pathfinding
	print("worker created")

	if astar_grid == null:
		astar_grid = AStarGrid2D.new()

		var used_rect = ground.get_used_rect()
		if used_rect.get_area() <= 0:
			push_warning("AStar grid region is empty")
			return

		astar_grid.region = used_rect
		astar_grid.cell_size = Vector2(16, 16)
		astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		astar_grid.update()

		var traversable_tml = world_layer_manager.build_traversable_tilemap()
		var traversable_qt = world_layer_manager.build_tml_quadtree(traversable_tml)

		var start_x = used_rect.position.x
		var end_x = start_x + used_rect.size.x
		var start_y = used_rect.position.y
		var end_y = start_y + used_rect.size.y

		for y in range(start_y, end_y):
			for x in range(start_x, end_x):
				var pos := Vector2i(x, y)
				var is_blocked := !traversable_qt.has(pos)
				astar_grid.set_point_solid(pos, is_blocked)

		system_movement_instance.astar_grid = astar_grid


func _on_layer_manager_world_created():
		print("creating initial worker")
		var new_entity_worker = ENTITY_WORKER.instantiate() # will add itself as a child of this node
		new_entity_worker.setup(world_layer_manager)
		var start_pos = find_ground()
		new_entity_worker.get_meta("component_sight").target_tile = start_pos
		add_child(new_entity_worker)
		new_entity_worker.position = ground.map_to_local(start_pos)
		new_entity_worker.map_location = start_pos
		worker_created.emit()
