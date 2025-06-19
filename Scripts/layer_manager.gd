class_name layer_manager extends Node

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

const MOUNTAIN_SOURCE_ID = 0
const MOUNTAIN_TILE_ATLAS_POS = Vector2i(5,0)

const SNOW_SOURCE_ID = 0
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
const BOTL_CLIFF_CORNER_TILE_ATLAS_POS= Vector2i(3,4)
const BOTR_CLIFF_CORNER_TILE_ATLAS_POS= Vector2i(4,4)
const TOPL_CLIFF_CORNER_TILE_ATLAS_POS= Vector2i(3,3)
const TOPR_CLIFF_CORNER_TILE_ATLAS_POS= Vector2i(4,3)

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
##total range of elevation in meters
@export var elevation_range = 20000 #~ mirinara trench to everest peak in feet
##ocean depth to sea level in meters
@export var sea_level = 11000
##distance between the start of the beach and the start of the ocean in meters
@export var beach_offset : int = 20
##elevation distance between sea level and the tree line in meters
@export var treeline_offset = 4000
## elevation distance between the tree line and the snow line
@export var snowline_offset = 1000
@export_subgroup("Noise Variables")
@export var scale = 0.5
## fractal steps of granularity > 1
@export var lacunarity = 2.35
## how much the granularity mixes > 0
@export var persistance = 0.50
## number of steps of granularity 
@export var octaves = 5.0
## custom offset input
@export var offset = Vector2i(0,0)
@export_subgroup("Feature Variance")
##1/tree_density ground tiles are trees
@export var tree_density = 100
@export_subgroup("Lake Formation")
##maximum number of water tiles that a lake can take up
@export var max_lake_size : int = 100
##maximum elevation difference to include in a local minima
@export var max_elev_varience : float = 33.0
 
#variables derived from world parameters
var shore_line = sea_level - beach_offset
var beach_line = sea_level + beach_offset
var tree_line = sea_level + treeline_offset
var snow_line = tree_line + snowline_offset


var tm_layers : Dictionary[String, TileMapLayer]
var layer_quadtrees : Dictionary[String, quad_tree_node]
var map : Dictionary[Vector2i,Array]

var elevation_matrix = [] : get = get_elevation_matrix

signal matrix_created
signal world_created

func _ready():
	elevation_matrix = generate_perlin_matrix(world_x, world_y, scale, offset)
	for child in get_children():
		if child is TileMapLayer:
			tm_layers[child.name.to_lower()] = child
			if child.get_child(0) is TileMapLayer:
				for sub_child in child.get_children():
					tm_layers[sub_child.name.to_lower()] = sub_child
	fill_ground_layers(elevation_matrix)
	paint_lakes(max_lake_size,max_elev_varience)
	fill_water_cliffs()
	round_water_cliffs()
	fill_mountain_cliffs()
	#build_traversable_tilemap()
	for layer in tm_layers:
		pass
		#layer_quadtrees[layer] = build_tml_quadtree(tm_layers[layer])
	make_map()
	world_created.emit()

func _process(delta):
	pass

## Return the elevation matrix used for world gen
##
##Returns the 2D Array used to store the elevation values of the tile locations of the generated map
func get_elevation_matrix():
	return elevation_matrix

## creates the map dictionary
##
## creates the map dictionary and fills vector2i keys with the tilemaplayers that have non empty cells at said Vector2i location
## returns void
func make_map():
	var new_map : Dictionary[Vector2i, Array] = {}
	for layer in tm_layers:
		var layer_pos = tm_layers[layer].get_used_cells()
		for pos in layer_pos:
			if not new_map.has(pos):
				new_map[pos] = []
			new_map[pos].append(layer)

			# Bounds check before accessing elevation_matrix
			if pos.x >= 0 and pos.x < elevation_matrix.size():
				if pos.y >= 0 and pos.y < elevation_matrix[pos.x].size():
					new_map[pos].append(elevation_matrix[pos.x][pos.y])
	map = new_map


## returns the map dictionary generated after world gen
func get_map() -> Dictionary[Vector2i,Array]:
	return map

## generate the elevation matrix based on perlin noise
func generate_perlin_matrix(x: int, y: int, scale: float, offset: Vector2) -> Array:
	print("generating perlin matrix for elevations")
	var matrix = []
	var noise = FastNoiseLite.new()
	noise.seed = randi()  # Random seed for variety
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.fractal_lacunarity = lacunarity
	noise.fractal_gain = persistance
	noise.fractal_octaves = octaves
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

## fill cliff layer cells with appropriete tile information based on ground and water layer information
func fill_water_cliffs():
	print("adding cliffs")
	var ground = tm_layers["ground"]
	var water = tm_layers["water"]
	var cliffs = tm_layers["cliffs"]
	var shore = tm_layers["shore"]
	var cliff_loc = []
	for i in range(world_x):
		for j in range(world_y):
			var pos = Vector2i(i,j)
			var ground_surrounding = tm_layers["ground"].get_surrounding_cells(pos)
			var shore_surrounding = tm_layers["shore"].get_surrounding_cells(pos)
			var ground_diagnals = []
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER )) # top left
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER )) # top left
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER )) # top left
			ground_diagnals.append(ground.get_neighbor_cell(pos, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER )) # top left
			var water_coords = water.get_cell_atlas_coords(pos)
			var empty_cell = Vector2i(-1,-1)
			#find adjacent cells and set appropriete cliff
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
			var shore_coords = shore.get_cell_atlas_coords(pos)
			if shore_coords != empty_cell:
				if cliffs.get_cell_atlas_coords(pos+Vector2i.LEFT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.DOWN) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.LEFT + Vector2i.DOWN) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, BOTL_CLIFF_CORNER_TILE_ATLAS_POS)
				if cliffs.get_cell_atlas_coords(pos+Vector2i.RIGHT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.DOWN) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.RIGHT + Vector2i.DOWN) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, BOTR_CLIFF_CORNER_TILE_ATLAS_POS)
				if cliffs.get_cell_atlas_coords(pos+Vector2i.LEFT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.UP) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.LEFT + Vector2i.UP) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, TOPL_CLIFF_CORNER_TILE_ATLAS_POS)
				if cliffs.get_cell_atlas_coords(pos+Vector2i.RIGHT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.UP) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.RIGHT + Vector2i.UP) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, TOPR_CLIFF_CORNER_TILE_ATLAS_POS) 

## fills cliff layer cells with appropriette corner tile information based on cliff and water layer information
func round_water_cliffs():
	var ground = tm_layers["ground"]
	var water = tm_layers["water"]
	var cliffs = tm_layers["cliffs"]
	var shore = tm_layers["shore"]
	var empty_cell = Vector2i(-1,-1)
	for i in range(world_x):
		for j in range(world_y):
			var pos = Vector2i(i,j)
			var shore_coords = shore.get_cell_atlas_coords(pos)
			if shore_coords != empty_cell:
				if cliffs.get_cell_atlas_coords(pos+Vector2i.LEFT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.DOWN) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.LEFT + Vector2i.DOWN) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, BOTL_CLIFF_CORNER_TILE_ATLAS_POS)
				if cliffs.get_cell_atlas_coords(pos+Vector2i.RIGHT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.DOWN) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.RIGHT + Vector2i.DOWN) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, BOTR_CLIFF_CORNER_TILE_ATLAS_POS)
				if cliffs.get_cell_atlas_coords(pos+Vector2i.LEFT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.UP) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.LEFT + Vector2i.UP) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, TOPL_CLIFF_CORNER_TILE_ATLAS_POS)
				if cliffs.get_cell_atlas_coords(pos+Vector2i.RIGHT) != empty_cell and cliffs.get_cell_atlas_coords(pos+Vector2i.UP) != empty_cell and water.get_cell_atlas_coords(pos + Vector2i.RIGHT + Vector2i.UP) != empty_cell:
					cliffs.set_cell(pos, WATER_CLIFF_SOURCE_ID, TOPR_CLIFF_CORNER_TILE_ATLAS_POS) 
	cliffs.set_cells_terrain_connect(cliffs.get_used_cells(),0,0)

## fill cliff layer cells with appropriete tile information based on ground and mountain layer information
func fill_mountain_cliffs():
	var mountains = tm_layers["mountains"]
	var ground = tm_layers["ground"]
	var ground_cells = ground.get_used_cells() 
	var mountain_cliff_pos = []
	for tile_pos in mountains.get_used_cells():
		mountain_cliff_pos.append(tile_pos)
		var neighboring_cells = ground.get_surrounding_cells(tile_pos)
		neighboring_cells.append(tile_pos+Vector2i.UP+Vector2i.LEFT)
		neighboring_cells.append(tile_pos+Vector2i.UP+Vector2i.RIGHT)
		neighboring_cells.append(tile_pos+Vector2i.DOWN+Vector2i.LEFT)
		neighboring_cells.append(tile_pos+Vector2i.DOWN+Vector2i.RIGHT)
		for cell in neighboring_cells:
			if ground_cells.has(cell):
				for neighbor_cell in neighboring_cells:
					if !ground_cells.has(neighbor_cell):
						if !mountain_cliff_pos.has(neighbor_cell):
							mountain_cliff_pos.append(neighbor_cell)
				continue
	
	tm_layers["cliffs"].set_cells_terrain_connect(mountain_cliff_pos,0,1,false)

## fill water,ground,mountain,tree, and shore layer cells with appropriete tile information based on the elevation matrix
func fill_ground_layers(elevation_matrix):
	print("filling ground tilemaplayers")
	var ground = tm_layers["ground"]
	var water = tm_layers["water"]
	var shore = tm_layers["shore"]
	var trees = tm_layers["trees"]
	var mountains = tm_layers["mountains"]
	var mountain_cliff_pos = []
	for i in range(world_x):
		for j in range(world_y):
			var pos = elevation_matrix[i][j]
			var map_pos = Vector2i(i,j)
			if( pos < (sea_level*0.75)):
				water.set_cell(map_pos, DEAP_WATER_SOURCE_ID, DEAP_WATER_TILE_ATLAS_POS)
			elif( pos < (shore_line)):
				water.set_cell(map_pos,WATER_SOURCE_ID,WATER_TILE_ATLAS_POS)#set tile with the water sprite
			elif(pos < beach_line):
				shore.set_cell(map_pos,SHORE_SOURCE_ID,SHORE_TILE_ATLAS_POS)#set tile with the beach sprite
			elif(pos < beach_line + beach_offset):
				shore.set_cell(map_pos,BEACH_SOURCE_ID,BEACH_TILE_ATLAS_POS)#set tile with the beach sprite
			elif(pos < tree_line):
				ground.set_cell(map_pos,GRASS_SOURCE_ID,GRASS_TILE_ATLAS_POS)#set tile with the grass sprite
				#if(randi()%tree_density < 1): #this works out to 2/tree_density but i like the results
					#trees.set_cell(map_pos, 0, Vector2i(randi()%3 + 1,0))
			elif(pos < snow_line):
				mountains.set_cell(map_pos,MOUNTAIN_SOURCE_ID,MOUNTAIN_TILE_ATLAS_POS)#set tile with the mountain sprite
			elif(pos > snow_line):
				mountains.set_cell(map_pos,SNOW_SOURCE_ID,SNOW_TILE_ATLAS_POS)#set tile with the snow sprite
			else:
				print()

## custom built WCF because i didnt know autotiling was a thing
func build_road(road_location : Vector2i):
	if layer_quadtrees["roads"].has(road_location):
		print("road already exists")
		update_road(road_location)
	else:
		tm_layers["roads"].set_cell(road_location,ROADS_SOURCE_ID,ROADS_4WAY_ATLAS_POS)
		layer_quadtrees["roads"].insert(road_location)
		update_road(road_location)

## helper function for build road
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

##builds a quadtreenode based on a tilemaplayer
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

## queries for an existing cell in a quadtreenode in the radius of center
##
## Arg 0 : "quad_tree" quad_tree_node - quad_tree_node to querie
## Arg 1 : "center" Vector2i - position of entity
## Arg 2 : "radius" int - distance to querie
func get_non_empty_cells_in_radius_quadtree(quad_tree: quad_tree_node, center: Vector2i, radius: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if quad_tree != null:
		quad_tree.query_circle(center, radius, result)
	return result

## queries for an existing cell in a layer in the radius of center
##
## Arg 0 : "layer_name" String - the name of the layer to querie
## Arg 1 : "center" Vector2i - position of entity
## Arg 2 : "radius" int - distance to querie
func get_non_empty_cells_in_radius(layer_name : String , center : Vector2i, radius: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var quad_tree = layer_quadtrees[layer_name]
	if quad_tree != null:
		quad_tree.query_circle(center, radius, result)
	else:
		print("quad tree is null returning empty array")
	return result

## combins tilemaplayers and returns the resulting tilmaplayer
##
## Arg 0 : "traversable_layers" Array[String] - the names of layers that are traversable by the entity
## Arg 1 : "obstical layers" Array[String] - the names of the layers that are obstacals for the entity to traverse
func build_traversable_tilemap(traversable_layers: Array = ["ground", "shore"], obstical_layers: Array = []) -> TileMapLayer:
	print("building traversable tilemap")

	var traversable_tilemap := TileMapLayer.new()

	# Step 1: Combine all traversable cells
	var traversable_cells := {}

	for layer_name in traversable_layers:
		var layer: TileMapLayer = tm_layers[layer_name]
		for cell in layer.get_used_cells():
			traversable_cells[cell] = {
			"source_id": layer.get_cell_source_id(cell),
			"atlas_coords": layer.get_cell_atlas_coords(cell),
			"alt_tile": layer.get_cell_alternative_tile(cell)
			}

	# Step 2: Mark all obstacle cells
	var blocked_cells := {}
	for obs_layer in obstical_layers:
		for cell in tm_layers[obs_layer].get_used_cells():
			blocked_cells[cell] = true

	# Step 3: Filter and add to traversable_tilemap
	for cell_pos in traversable_cells.keys():
		if not blocked_cells.has(cell_pos):
			var tile = traversable_cells[cell_pos]
			traversable_tilemap.set_cell(
				cell_pos,
				tile["source_id"],
				tile["atlas_coords"],
				tile["alt_tile"]
			)

	return traversable_tilemap

func find_minima(elevation_matrix: Array, max_lake_size : int, lake_appearrance : float) -> Array:
	var width = elevation_matrix.size()
	var height = elevation_matrix[0].size()
	var minima := []

	for y in range(1, height - 1):
		for x in range(1, width - 1):
			var current = elevation_matrix[x][y]
			var is_min = true

			for dy in range(-1, 2):
				for dx in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var neighbor = elevation_matrix[x + dx][y + dy]
					if neighbor < current:
						is_min = false
						break
				if not is_min:
					break

			if is_min and randi() % (max_lake_size/2) < (lake_appearrance):
				minima.append(Vector2i(x, y))
	return minima

func find_local_minima(elevation_matrix: Array , elevation_threshold := 10) -> Array:
	var width = elevation_matrix.size()
	var height = elevation_matrix[0].size()
	var minima := []

	for y in range(1, height - 1):
		for x in range(1, width - 1):
			var current = elevation_matrix[x][y]
			var is_min = true

			for dy in range(-1, 2):
				for dx in range(-1, 2):
					if dx == 0 and dy == 0:
						continue
					var neighbor = elevation_matrix[x + dx][y + dy]
					if neighbor < current - elevation_threshold:
						is_min = false
						break
				#if not is_min:
					#break

			if is_min:
				minima.append(Vector2i(x, y))
	return minima

##paints in lakes to the tilemap, does not adjust the elevation matrix
##
##max_lake_size : int = 50 | the maximum number of tiles a generated lake will contain
##elevation_treshold : float = 10.0 | the maximum difference in elevation two tiles can be while still being a continuation of a lake
##lake distribution : int = 2 | 1 lake per lake_distribution/(max_lake_size/2)
func paint_lakes(max_lake_size : int = 50, elevation_threshold : float = 10.0  , lake_distribution : int = 2) -> void:
	var width = elevation_matrix.size()
	var height = elevation_matrix[0].size()
	var visited := {}
	
	var global_minima := find_minima(elevation_matrix, max_lake_size,2)
	var local_minima := find_local_minima(elevation_matrix, elevation_threshold)
	var ground_cells = tm_layers["ground"].get_used_cells()
	var tree_pos = tm_layers["trees"].get_used_cells()
	var mountain_pos = tm_layers["mountains"].get_used_cells()

	for seed in global_minima:
		if seed in visited:
			continue
		
		if !ground_cells.has(seed):
			continue
		
		var lake_tiles := []
		var queue := [seed]
		visited[seed] = true

		while queue.size() > 0 and lake_tiles.size() < max_lake_size:
			var current = queue.pop_front()
			lake_tiles.append(current)

			for neighbor in get_all_neighboring_positions(current):
				if neighbor.x < 0 or neighbor.y < 0 or neighbor.x >= width or neighbor.y >= height:
					continue
				if neighbor in visited:
					continue
				if elevation_matrix[neighbor.x][neighbor.y] > elevation_matrix[current.x][current.y] + elevation_threshold:
					continue

				queue.append(neighbor)
				visited[neighbor] = true
		
		if lake_tiles.size() > 1:
			for tile_pos in lake_tiles:
				if mountain_pos.has(tile_pos):
					continue
				tm_layers["water"].set_cell(tile_pos, WATER_SOURCE_ID, WATER_TILE_ATLAS_POS)
				if tree_pos.has(tile_pos):
					tm_layers["trees"].set_cell(tile_pos)
				if ground_cells.has(tile_pos):
					tm_layers["ground"].set_cell(tile_pos)

func get_all_neighboring_positions(pos : Vector2i, inclusive : bool = false) -> Array[Vector2i]:
	var neighbors : Array[Vector2i] = []
	neighbors.append(pos+Vector2i.UP+Vector2i.LEFT)
	neighbors.append(pos+Vector2i.UP)
	neighbors.append(pos+Vector2i.UP+Vector2i.RIGHT)
	neighbors.append(pos+Vector2i.RIGHT)
	neighbors.append(pos+Vector2i.DOWN+Vector2i.RIGHT)
	neighbors.append(pos+Vector2i.DOWN)
	neighbors.append(pos+Vector2i.DOWN+Vector2i.LEFT)
	neighbors.append(pos+Vector2i.LEFT)
	if inclusive:
		neighbors.append(pos)
	return neighbors
