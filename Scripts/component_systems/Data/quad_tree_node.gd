class_name quad_tree_node
extends Node

var rect: Rect2i
var tiles: Array[Vector2i] = []
var children: Array = []

const MAX_TILES := 10
const MAX_DEPTH := 6

func _init(rect: Rect2i):
	self.rect = rect

func insert(tile_pos: Vector2i, depth := 0):
	if not rect.has_point(tile_pos):
		return  # Out of bounds, do nothing

	# If node is a leaf and has space or max depth reached, add directly
	if children.is_empty():
		if tiles.size() < MAX_TILES or depth >= MAX_DEPTH:
			if tile_pos not in tiles:
				tiles.append(tile_pos)
			return
		else:
			_subdivide()
			# Redistribute existing tiles into children
			for old_tile in tiles:
				for child in children:
					if child.rect.has_point(old_tile):
						child.insert(old_tile, depth + 1)
						break
			tiles.clear()  # Clear after redistribution

	# After subdivision, pass to correct child
	for child in children:
		if child.rect.has_point(tile_pos):
			child.insert(tile_pos, depth + 1)
			return

func _subdivide():
	if not children.is_empty():
		return  # Already subdivided

	var half_size = rect.size / 2
	children.append(quad_tree_node.new(Rect2i(rect.position, half_size)))
	children.append(quad_tree_node.new(Rect2i(rect.position + Vector2i(half_size.x, 0), half_size)))
	children.append(quad_tree_node.new(Rect2i(rect.position + Vector2i(0, half_size.y), half_size)))
	children.append(quad_tree_node.new(Rect2i(rect.position + half_size, half_size)))

func query_circle(center: Vector2i, radius: int, result: Array[Vector2i]):
	if not _rect_intersects_circle(rect, center, radius):
		return

	var radius_squared = radius * radius
	for tile in tiles:
		var delta = tile - center
		if delta.length_squared() <= radius_squared:
			result.append(tile)

	for child in children:
		child.query_circle(center, radius, result)

func _rect_intersects_circle(rect: Rect2i, center: Vector2i, radius: int) -> bool:
	var closest_x = clamp(center.x, rect.position.x, rect.position.x + rect.size.x)
	var closest_y = clamp(center.y, rect.position.y, rect.position.y + rect.size.y)
	var dx = center.x - closest_x
	var dy = center.y - closest_y
	return (dx * dx + dy * dy) <= (radius * radius)

func remove(tile_pos: Vector2i) -> bool:
	if not rect.has_point(tile_pos):
		return false

	if tile_pos in tiles:
		tiles.erase(tile_pos)
		return true

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
