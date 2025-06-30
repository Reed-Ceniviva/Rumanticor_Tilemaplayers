extends ColorRect
class_name SelectionRect

@export var tile_size := 16
@onready var camera := get_viewport().get_camera_2d()

var is_selecting := false
var selection_start : Vector2
var selection_end : Vector2
var selected_tiles : Array[Vector2i] = []

signal area_selected(selected_tiles: Array[Vector2i])

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			is_selecting = true
			selection_start = screen_to_world(event.position)
			selection_end = selection_start
		else:
			is_selecting = false
			process_selection()
	elif event is InputEventMouseMotion and is_selecting:
		selection_end = screen_to_world(event.position)

func screen_to_world(screen_pos: Vector2) -> Vector2:
	var viewport_center = get_viewport_rect().size * 0.5
	var offset = screen_pos - viewport_center
	var world_pos = camera.global_position + offset / camera.zoom
	return world_pos

func world_to_screen(world_pos: Vector2) -> Vector2:
	var viewport_center = get_viewport_rect().size * 0.5
	var offset = (world_pos - camera.global_position) * camera.zoom
	var screen_pos = viewport_center + offset
	return screen_pos

func world_to_map(world_pos: Vector2) -> Vector2i:
	return Vector2i(
		floor(world_pos.x / tile_size),
		floor(world_pos.y / tile_size)
	)

func _draw():
	if is_selecting:
		var tile_start = world_to_map(selection_start)
		var tile_end = world_to_map(selection_end)

		var top_left = Vector2(
			min(tile_start.x, tile_end.x),
			min(tile_start.y, tile_end.y)
		)
		var bottom_right = Vector2(
			max(tile_start.x, tile_end.x),
			max(tile_start.y, tile_end.y)
		) + Vector2(1, 1)

		var world_top_left = top_left * tile_size
		var world_size = (bottom_right - top_left) * tile_size

		var screen_top_left = world_to_screen(world_top_left)
		var screen_size = world_size * camera.zoom

		var rect = Rect2(screen_top_left, screen_size)

		draw_rect(rect, Color(0, 1, 0, 0.25), true)
		draw_rect(rect, Color(0, 1, 0), false)

func _process(_delta):
	queue_redraw()

func process_selection():
	selected_tiles.clear()

	var tile_start = world_to_map(selection_start)
	var tile_end = world_to_map(selection_end)

	var min_x = min(tile_start.x, tile_end.x)
	var max_x = max(tile_start.x, tile_end.x)
	var min_y = min(tile_start.y, tile_end.y)
	var max_y = max(tile_start.y, tile_end.y)

	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			selected_tiles.append(Vector2i(x, y))

	print("Selected tiles:", selected_tiles)
	area_selected.emit(selected_tiles)
