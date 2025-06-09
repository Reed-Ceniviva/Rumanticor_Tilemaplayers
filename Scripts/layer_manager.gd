class_name layer_manager extends Node
#this seems to be the best way of doing this at the moment


const GRASS_SOURCE_ID = 0
const GRASS_TILE_ATLAS_POS = Vector2i(0,0)

const WATER_SOURCE_ID = 0
const WATER_TILE_ATLAS_POS = Vector2i(3,0)

const DEAP_WATER_SOURCE_ID = 0
const DEAP_WATER_TILE_ATLAS_POS = Vector2i(4,0)

const SHORE_SOURCE_ID = 0
const SHORE_TILE_ATLAS_POS = Vector2i(1,0)

const BEACH_SOURCE_ID = 0
const BEACH_TILE_ATLAS_POS = Vector2i(0,0)

const MOUNTAIN_SOURCE_ID = 4
const MOUNTAIN_TILE_ATLAS_POS = Vector2i(5,0)

const SNOW_SOURCE_ID = 4
const SNOW_TILE_ATLAS_POS = Vector2i(4,0)

const WATER_CLIFF_SOURCE_ID = 0
const LEFT_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(0,4)
const TOP_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(1,3)
const RIGHT_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(2,4)
const BOT_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(1,5)
const BOTL_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(0,5)
const BOTR_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(2,5)
const TOPL_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(0,3)
const TOPR_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(2,3)

const ROADS_SOURCE_ID = 0
const ROADS_VERTICAL_ATLAS_POS = Vector2i(0,0)
const ROADS_HORIZONTAL_ATLAS_POS = Vector2i(1,0)
const ROADS_4WAY_ATLAS_POS = Vector2i(2,0)
const ROADS_LB_CORNER_ATLAS_POS = Vector2i(3,0)
const ROADS_RB_CORNER_ATLAS_POS = Vector2i(4,0)
const ROADS_LTB_INT_ATLAS_POS = Vector2i(0,1)
const ROADS_LRB_INT_ATLAS_POS = Vector2i(1,1)
const ROADS_RTB_INT_ATLAS_POS = Vector2i(2,1)
const ROADS_LT_CORNER_ATLAS_POS = Vector2i(3,1)
const ROADS_RT_CORNER_ATLAS_POS = Vector2i(4,1)
const ROADS_LRT_INT_ATLAS_POS = Vector2i(0,2)


@export_group("World Parameters")
@export_subgroup("Size")
@export var world_x = 640
@export var world_y = 640
@export_subgroup("Elevation Markers")
@export var elevation_range = 65000 #~ mirinara trench to everest peak in feet
@export var sea_level = 36000
@export var beach_offset : int = 50
@export var treeline_offset = 13000
@export var snowline_offset = 2500
@export_subgroup("Noise Variables")
@export var elevation_varience = 0.5 #controls the amount of varience in elevation in the world
@export_subgroup("Feature Variance")
@export var tree_density = 200#2 in x grass tiles have trees
 
#variables derived from world parameters
var shore_line = sea_level - beach_offset
var beach_line = sea_level + beach_offset
var tree_line = sea_level + treeline_offset
var snow_line = tree_line + snowline_offset
var offset = Vector2i(0,0)

var tm_layers : Dictionary[String, TileMapLayer]
var layer_quadtrees : Dictionary[String, quad_tree_node]

var elevation_matrix = [] : get = get_elevation_matrix

signal matrix_created
signal world_created

func _ready():
	elevation_matrix = generate_perlin_matrix(world_x, world_y, elevation_varience, offset)
	for child in get_children():
		if child is TileMapLayer:
			tm_layers[child.name.to_lower()] = child
			if child.get_child(0) is TileMapLayer:
				for sub_child in child.get_children():
					tm_layers[sub_child.name.to_lower()] = sub_child
	fill_ground_layers(elevation_matrix)
	fill_water_cliffs()
	for layer in tm_layers:
		layer_quadtrees[layer] = build_tml_quadtree(tm_layers[layer])
	world_created.emit()
	
func _process(delta):
	pass

func get_elevation_matrix():
	return elevation_matrix

	
func generate_perlin_matrix(x: int, y: int, scale: float, offset: Vector2) -> Array:
	print("generating perlin matrix for elevations")
	var matrix = []
	var noise = FastNoiseLite.new()
	noise.seed = randi()  # Random seed for variety
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	for i in range(y):
		var row = []
		for j in range(x):
			# Generate Perlin noise value for each point
			var perlin_value = noise.get_noise_2d((j+offset.x) * scale, (i+offset.y) * scale)
			# Scale and shift the Perlin noise value to the desired range [-35000, 30000]
			var scaled_value = lerp(0, elevation_range, (perlin_value + 1.0) / 2.0)
			row.append(scaled_value)
		matrix.append(row)
	#print(matrix)
	matrix_created.emit()
	return matrix

func fill_water_cliffs():
	print("adding cliffs")
	var ground = tm_layers["ground"]
	var water = tm_layers["water"]
	var cliffs = tm_layers["cliffs"]
	for i in range(world_x):
		for j in range(world_y):
			var pos = Vector2i(i,j)
			var ground_surrounding = tm_layers["ground"].get_surrounding_cells(pos)
			var ground_diagnals = []
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER )) # top left
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER )) # top left
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER )) # top left
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER )) # top left
			var water_coords = water.get_cell_atlas_coords(pos)
			var empty_cell = Vector2i(-1,-1)
			if water_coords != empty_cell:
				if ground.get_cell_atlas_coords(ground_surrounding[2]) != empty_cell: #ground to the left
					cliffs.set_cell(pos,WATER_CLIFF_SOURCE_ID, RIGHT_WATER_CLIFF_TILE_ATLAS_POS)
				elif ground.get_cell_atlas_coords(ground_surrounding[0]) != empty_cell: #ground to the right
					cliffs.set_cell(pos,WATER_CLIFF_SOURCE_ID, LEFT_WATER_CLIFF_TILE_ATLAS_POS)
				elif ground.get_cell_atlas_coords(ground_surrounding[1]) != empty_cell: #ground bellow
					cliffs.set_cell(pos,WATER_CLIFF_SOURCE_ID, TOP_WATER_CLIFF_TILE_ATLAS_POS)
				elif ground.get_cell_atlas_coords(ground_surrounding[3]) != empty_cell: #ground above
					cliffs.set_cell(pos,WATER_CLIFF_SOURCE_ID, BOT_WATER_CLIFF_TILE_ATLAS_POS)
				elif ground.get_cell_atlas_coords(ground_diagnals[3]) != empty_cell: #ground top left
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, TOPL_WATER_CLIFF_TILE_ATLAS_POS)
				elif ground.get_cell_atlas_coords(ground_diagnals[2]) != empty_cell: #ground top Right
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, TOPR_WATER_CLIFF_TILE_ATLAS_POS)
				elif ground.get_cell_atlas_coords(ground_diagnals[1]) != empty_cell: #top right
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, BOTL_WATER_CLIFF_TILE_ATLAS_POS)
				elif ground.get_cell_atlas_coords(ground_diagnals[0]) != empty_cell: #top left
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, BOTR_WATER_CLIFF_TILE_ATLAS_POS)
			
			
func fill_ground_layers(elevation_matrix):
	print("filling ground tilemaplayers")
	var ground = tm_layers["ground"]
	var water = tm_layers["water"]
	var shore = tm_layers["shore"]
	var trees = tm_layers["trees"]
	
	for i in range(world_x):
		for j in range(world_y):
			var pos = elevation_matrix[i][j]
			if( pos < (sea_level*0.75)):
				water.set_cell(Vector2i(i,j), DEAP_WATER_SOURCE_ID, DEAP_WATER_TILE_ATLAS_POS)
			elif( pos < (shore_line)):
				water.set_cell(Vector2i(i,j),WATER_SOURCE_ID,WATER_TILE_ATLAS_POS)#set tile with the water sprite
			elif(pos < beach_line):
				shore.set_cell(Vector2i(i,j),SHORE_SOURCE_ID,SHORE_TILE_ATLAS_POS)#set tile with the beach sprite
			elif(pos < beach_line + beach_offset):
				shore.set_cell(Vector2i(i,j),BEACH_SOURCE_ID,BEACH_TILE_ATLAS_POS)#set tile with the beach sprite
			elif(pos < tree_line):
				ground.set_cell(Vector2i(i,j),GRASS_SOURCE_ID,GRASS_TILE_ATLAS_POS)#set tile with the grass sprite
				if(randi()%tree_density <= 1): #this works out to 2/tree_density but i like the results
					trees.set_cell(Vector2i(i,j), 0, Vector2i(randi()%3 + 1,0))
			elif(pos < snow_line):
				ground.set_cell(Vector2i(i,j),MOUNTAIN_SOURCE_ID,MOUNTAIN_TILE_ATLAS_POS)#set tile with the mountain sprite
			elif(pos > snow_line):
				ground.set_cell(Vector2i(i,j),SNOW_SOURCE_ID,SNOW_TILE_ATLAS_POS)#set tile with the snow sprite
			else:
				print()

func build_road(road_location : Vector2i):
	if layer_quadtrees["roads"].has(road_location):
		print("road already exists")
		update_road(road_location)
	else:
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_4WAY_ATLAS_POS)
		layer_quadtrees["roads"].insert(road_location)
		update_road(road_location)
	

func update_road(road_location : Vector2i):
	var adjacent_roads = get_non_empty_cells_in_radius("roads",road_location,1)
	var left = road_location + Vector2i.LEFT
	var right = road_location + Vector2i.RIGHT
	var top = road_location + Vector2i.UP
	var bot = road_location + Vector2i.DOWN
	adjacent_roads.erase(road_location)
	if adjacent_roads.size() == 0:
		pass
	elif adjacent_roads.size() == 4:
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_4WAY_ATLAS_POS)
	elif adjacent_roads.has(left) and adjacent_roads.has(right) and adjacent_roads.has(top):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_LRT_INT_ATLAS_POS)
	elif adjacent_roads.has(left) and adjacent_roads.has(right) and adjacent_roads.has(bot):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_LRB_INT_ATLAS_POS)
	elif adjacent_roads.has(left) and adjacent_roads.has(top) and adjacent_roads.has(bot):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_LTB_INT_ATLAS_POS)
	elif adjacent_roads.has(right) and adjacent_roads.has(top) and adjacent_roads.has(bot):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_RTB_INT_ATLAS_POS)
	elif adjacent_roads.has(left) and adjacent_roads.has(top):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_LT_CORNER_ATLAS_POS)
	elif adjacent_roads.has(left) and adjacent_roads.has(bot):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_LB_CORNER_ATLAS_POS)
	elif adjacent_roads.has(right) and adjacent_roads.has(top):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_RT_CORNER_ATLAS_POS)
	elif adjacent_roads.has(right) and adjacent_roads.has(bot):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_RB_CORNER_ATLAS_POS)
	elif adjacent_roads.has(right) or adjacent_roads.has(left):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_HORIZONTAL_ATLAS_POS)
	elif adjacent_roads.has(top) or adjacent_roads.has(bot):
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_VERTICAL_ATLAS_POS)
	else:
		pass

#builds a quadtreenode based on a tilemaplayer
func build_tml_quadtree(reference: TileMapLayer) -> quad_tree_node:
	print("building quadtree based on a tilemaplayer") 
	var used_cells = reference.get_used_cells()
	if used_cells.is_empty(): #create an empty quadtree if the tilemaplayer is empty
		return quad_tree_node.new(tm_layers["ground"].get_used_rect()) #need to use a rect that contains all possible points cause im lazy rn
		
	var min_pos = used_cells[0]
	var max_pos = used_cells[0]
	
# Find map bounds
	for cell in used_cells:
		min_pos = Vector2i(min(min_pos.x, cell.x), min(min_pos.y, cell.y))
		max_pos = Vector2i(max(max_pos.x, cell.x), max(max_pos.y, cell.y))
		
	var rect = Rect2i(min_pos, max_pos - min_pos + Vector2i(1,1))
	
	var target_qt = quad_tree_node.new(rect)
	for cell in used_cells:
		target_qt.insert(cell)
	return target_qt

func get_non_empty_cells_in_radius_quadtree(quad_tree: quad_tree_node, center: Vector2i, radius: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if quad_tree != null:
		quad_tree.query_circle(center, radius, result)
	return result

func get_non_empty_cells_in_radius(layer_name : String , center : Vector2i, radius: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var quad_tree = layer_quadtrees[layer_name]
	if quad_tree != null:
		quad_tree.query_circle(center, radius, result)
	else:
		print("quad tree is null returning empty array")
	return result

func build_traversable_tilemap(traversable_layers: Array = ["ground", "shore"], obstical_layers: Array = []) -> TileMapLayer:
	print("building traversable tilemap")

	var traversable_tilemap := TileMapLayer.new()

	# Step 1: Combine all traversable cells
	var traversable_cells := {}

	for layer_name in traversable_layers:
		var layer: TileMapLayer = tm_layers[layer_name]
		for cell in layer.get_used_cells():
			traversable_cells[cell] = layer  # Save reference to layer for source/tile info

	# Step 2: Mark all obstacle cells
	var blocked_cells := {}
	for obs_layer in obstical_layers:
		for cell in tm_layers[obs_layer].get_used_cells():
			blocked_cells[cell] = true

	# Step 3: Filter and add to traversable_tilemap
	for cell_pos in traversable_cells.keys():
		if not blocked_cells.has(cell_pos):
			var layer = traversable_cells[cell_pos]
			traversable_tilemap.set_cell(
				cell_pos,
				layer.get_cell_source_id(cell_pos),
				layer.get_cell_atlas_coords(cell_pos),
				layer.get_cell_alternative_tile(cell_pos)
			)

	return traversable_tilemap
