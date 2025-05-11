class_name layer_manager extends Node

@onready var ground = $Ground
@onready var water = $Water
@onready var shore = $Shore
@onready var cliffs = $Cliffs
@onready var trees = $Trees
@onready var debris = $Debris
@onready var buildings = $Building_Manager/Buildings

var child_layers : get = get_child_layers


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

const LEFT_WATER_CLIFF_SOURCE_ID = 0
const LEFT_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(0,4)

const TOP_WATER_CLIFF_SOURCE_ID = 0
const TOP_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(1,3)

const RIGHT_WATER_CLIFF_SOURCE_ID = 0
const RIGHT_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(2,4)

const BOT_WATER_CLIFF_SOURCE_ID = 0
const BOT_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(1,5)

const BOTL_WATER_CLIFF_SOURCE_ID = 0
const BOTL_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(0,5)

const BOTR_WATER_CLIFF_SOURCE_ID = 0
const BOTR_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(2,5)

const TOPL_WATER_CLIFF_SOURCE_ID = 0
const TOPL_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(0,3)

const TOPR_WATER_CLIFF_SOURCE_ID = 0
const TOPR_WATER_CLIFF_TILE_ATLAS_POS = Vector2i(2,3)


@export_group("World Parameters")
@export_subgroup("Size")
@export var world_x = 640
@export var world_y = 640
@export_subgroup("Elevation Markers")
@export var elevation_range = 65000
@export var sea_level = 36000
@export var beach_offset : int = 100
@export var treeline_offset = 13000
@export var snowline_offset = 2500
@export_subgroup("Noise Variables")
@export var elevation_varience = 0.5 #controls the amount of varience in elevation in the world
@export_subgroup("Feature Variance")
@export var tree_density = 200#1 in x grass tiles have trees
@export var hut_density = 100


var shore_line = sea_level - beach_offset
var beach_line = sea_level + beach_offset
var tree_line = sea_level + treeline_offset
var snow_line = tree_line + snowline_offset
var offset = Vector2i(0,0)


var elevation_matrix = [] : get = get_elevation_matrix

var ground_quadtree: quad_tree_node : get = get_ground_qt, set = set_ground_qt
var tree_quadtree: quad_tree_node : get = get_tree_qt, set = set_tree_qt
var building_quadtree: quad_tree_node : get = get_building_qt, set = set_building_qt

signal matrix_created
signal tile_map_filled
signal quadtree_created

func _ready():
	elevation_matrix = generate_perlin_matrix(world_x, world_y, elevation_varience, offset)
	fill_ground_layers(elevation_matrix)
	fill_water_cliffs()
	tile_map_filled.emit()
	
func _process(delta):
	pass

func get_ground_qt() -> quad_tree_node:
	return ground_quadtree
	
func get_tree_qt():
	return tree_quadtree

func get_building_qt():
	return building_quadtree

func set_building_qt(new_qt : quad_tree_node):
	building_quadtree = new_qt

func set_ground_qt(new_quadtree):
	ground_quadtree = new_quadtree
	
func set_tree_qt(new_quadtree):
	tree_quadtree = new_quadtree

func get_child_layers():
	var temp_layers = []
	for child in get_children():
		if child is TileMapLayer:
			temp_layers.append(child)
	return temp_layers

func get_elevation_matrix():
	return elevation_matrix

func get_sea_level():
	return sea_level

func tree_chopped(tree_loc : Vector2i):
	print("tree chopped: adjusting tilemap and quadtree")
	debris.set_cell(tree_loc, 0, Vector2i(0,0))
	trees.set_cell(tree_loc,-1,Vector2i(-1,-1))
	tree_quadtree.remove(tree_loc)

func hut_built(hut_loc : Vector2i):
	print("hut built: adjusting tilemap and quadtree")
	buildings.set_cell(hut_loc, 0, Vector2i(1,0))
	building_quadtree = build_tml_quadtree(buildings)
	
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
	for i in range(world_x):
		for j in range(world_y):
			var pos = Vector2i(i,j)
			var ground_surrounding = ground.get_surrounding_cells(pos)
			var empty_cell = Vector2i(-1,-1)
			if ground.get_cell_atlas_coords(ground_surrounding[2]) != empty_cell and water.get_cell_atlas_coords(pos) != empty_cell: #ground to the left
				cliffs.set_cell(pos,RIGHT_WATER_CLIFF_SOURCE_ID, RIGHT_WATER_CLIFF_TILE_ATLAS_POS)
			elif ground.get_cell_atlas_coords(ground_surrounding[0]) != empty_cell and water.get_cell_atlas_coords(pos) != empty_cell: #ground to the right
				cliffs.set_cell(pos,LEFT_WATER_CLIFF_SOURCE_ID, LEFT_WATER_CLIFF_TILE_ATLAS_POS)
			elif ground.get_cell_atlas_coords(ground_surrounding[1]) != empty_cell and water.get_cell_atlas_coords(pos) != empty_cell: #ground bellow
				cliffs.set_cell(pos,TOP_WATER_CLIFF_SOURCE_ID, TOP_WATER_CLIFF_TILE_ATLAS_POS)
			elif ground.get_cell_atlas_coords(ground_surrounding[3]) != empty_cell and water.get_cell_atlas_coords(pos) != empty_cell: #ground above
				cliffs.set_cell(pos,BOT_WATER_CLIFF_SOURCE_ID, BOT_WATER_CLIFF_TILE_ATLAS_POS)
	
func fill_ground_layers(elevation_matrix):
	#var tree_hit = 0
	print("filling ground tilemaplayers")
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
				if(randi()%200 <= 1):
					trees.set_cell(Vector2i(i,j), 0, Vector2i(randi()%3 + 1,0))
			elif(pos < snow_line):
				ground.set_cell(Vector2i(i,j),MOUNTAIN_SOURCE_ID,MOUNTAIN_TILE_ATLAS_POS)#set tile with the mountain sprite
			elif(pos > snow_line):
				ground.set_cell(Vector2i(i,j),SNOW_SOURCE_ID,SNOW_TILE_ATLAS_POS)#set tile with the snow sprite
			else:
				print()

#this should loop through navigable tilemap layers and compile them into one quadtree to check for movement
func build_tml_quadtree(reference: TileMapLayer) -> quad_tree_node:
	print("building quadtree based on a tilemaplayer") 
	var used_cells = reference.get_used_cells()
	if used_cells.is_empty():
		print("created empty quadtrees")
		return quad_tree_node.new(reference.get_used_rect())

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
	print("getting non empty cells in: ", String(quad_tree.name) , "\nat position: " , center, " \n in the radius of : ", radius)
	var result: Array[Vector2i] = []
	if quad_tree != null:
		quad_tree.query_circle(center, radius, result)
	print("result: ",result)
	return result

func _on_tile_map_filled():
	print("creating quad tree")
	ground_quadtree = build_tml_quadtree(ground)
	quadtree_created.emit()
	print("creating quad tree")
	tree_quadtree = build_tml_quadtree(trees)
	quadtree_created.emit()
	print("creating quad tree")
	building_quadtree = build_tml_quadtree(buildings)
	quadtree_created.emit()
