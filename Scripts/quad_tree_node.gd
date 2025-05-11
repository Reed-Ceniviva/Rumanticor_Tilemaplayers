class_name quad_tree_node extends Node

var rect: Rect2i
var tiles: Array[Vector2i] = []
var children: Array = []

const MAX_CAPACITY := 4  # or 8, depending on granularity
var max_tiles = 10
var max_depth = 6

func _init(rect: Rect2i):
	self.rect = rect
	
func insert(tile_pos: Vector2i, depth := 0):
	if not rect.has_point(tile_pos):
		return
	if tiles.size() < max_tiles or depth >= max_depth:
		tiles.append(tile_pos)
	else:
		if children.is_empty():
			_subdivide()
	for child in children:
		child.insert(tile_pos, depth + 1)

func test_insert(tile_pos: Vector2i):
	if not rect.has_point(tile_pos):
		push_error("insert(): tile_pos %s is out of bounds of QuadTreeNode rect %s" % [tile_pos, rect])
		return

	# If already subdivided, pass it to the correct child
	if children.size() > 0:
		for child in children:
			if child.rect.has_point(tile_pos):
				child.insert(tile_pos)
				return

	# If not subdivided and capacity exceeded, subdivide
	tiles.append(tile_pos)

	if tiles.size() > MAX_CAPACITY:
		_subdivide()
		# Reinsert existing tiles into children
		for t in tiles:
			for child in children:
				if child.rect.has_point(t):
					child.insert(t)
					break
			tiles.clear()

func _subdivide():
	var half_size = rect.size / 2
	children.append(quad_tree_node.new(Rect2i(rect.position, half_size)))
	children.append(quad_tree_node.new(Rect2i(rect.position + Vector2i(half_size.x, 0), half_size)))
	children.append(quad_tree_node.new(Rect2i(rect.position + Vector2i(0, half_size.y), half_size)))
	children.append(quad_tree_node.new(Rect2i(rect.position + half_size, half_size)))

func query_circle(center: Vector2i, radius: int, result: Array[Vector2i]):
	# If this node is completely outside the circle, skip
	if !_rect_intersects_circle(rect, center, radius):
		return
		
	# Check tiles in this node
	var radius_squared = radius * radius
	for tile in tiles:
		var delta = tile - center
		if delta.length_squared() <= radius_squared:
			result.append(tile)
			
# Recurse into children
	for child in children:
		child.query_circle(center, radius, result)

func _rect_intersects_circle(rect: Rect2i, center: Vector2i, radius: int) -> bool:
	# Fast rectangle vs circle check
	var closest_x = clamp(center.x, rect.position.x, rect.position.x + rect.size.x)
	var closest_y = clamp(center.y, rect.position.y, rect.position.y + rect.size.y)
	var dx = center.x - closest_x
	var dy = center.y - closest_y
	return (dx * dx + dy * dy) <= (radius * radius)


func remove(tile_pos: Vector2i) -> bool:
	if not rect.has_point(tile_pos):
		return false
	
	# Try to remove from current node
	if tile_pos in tiles:
		tiles.erase(tile_pos)
		return true
	
	# Try to remove from children
	for child in children:
		if child.remove(tile_pos):
			return true

	return false


func has(tile_pos: Vector2i) -> bool:
	if not rect.has_point(tile_pos):
		return false
	
	if tile_pos in tiles:
		return true
	
	for child in children:
		if child.has(tile_pos):
			return true
	
	return false
