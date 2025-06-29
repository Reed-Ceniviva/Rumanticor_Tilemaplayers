extends ColorRect
class_name SelectionRect

@export var tile_size := 16
@onready var camera := get_viewport().get_camera_2d()

var is_selecting := false
var selection_start := Vector2i()
var selection_end := Vector2i()
var selected_tiles : Array[Vector2i] = []
var precise_selection_start_world = Vector2()

signal area_selected(selected_tiles: Array[Vector2i])

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			var zoom = camera.zoom
			var viewport_center = get_viewport_rect().size * 0.5
			var screen_delta = event.position - viewport_center
			var world_pos = camera.global_position + screen_delta * zoom

			var tile_pos = world_to_map(world_pos)

			if event.pressed:
				is_selecting = true
				selection_start = tile_pos
				selection_end = tile_pos
				precise_selection_start_world = world_pos
			else:
				is_selecting = false
				process_selection()
	elif event is InputEventMouseMotion and is_selecting:
		var zoom = camera.zoom
		var viewport_center = get_viewport_rect().size * 0.5
		var screen_delta = event.position - viewport_center
		var world_pos = camera.global_position + screen_delta * zoom
		selection_end = world_to_map(world_pos)

func screen_to_world(screen_pos: Vector2) -> Vector2:
	var viewport_size = get_viewport_rect().size
	var offset_from_center = screen_pos - viewport_size * 0.5
	var world_pos = camera.global_position + offset_from_center / camera.zoom
	return world_pos

func world_to_map(world_pos: Vector2) -> Vector2i:
	return Vector2i(floor(world_pos.x / tile_size), floor(world_pos.y / tile_size))

func _draw():
	if is_selecting:
		var top_left = Vector2(
			min(selection_start.x, selection_end.x),
			min(selection_start.y, selection_end.y)
		)
		var bottom_right = Vector2(
			max(selection_start.x, selection_end.x),
			max(selection_start.y, selection_end.y)
		) + Vector2(1, 1)

		var rect = Rect2(top_left * tile_size, (bottom_right - top_left) * tile_size)
		draw_rect(rect, Color(0, 1, 0, 0.25), true)
		draw_rect(rect, Color(0, 1, 0), false)

func _process(_delta):
	queue_redraw()

func process_selection():
	selected_tiles.clear()

	var min_x = min(selection_start.x, selection_end.x)
	var max_x = max(selection_start.x, selection_end.x)
	var min_y = min(selection_start.y, selection_end.y)
	var max_y = max(selection_start.y, selection_end.y)

	for y in range(min_y, max_y + 1):
		for x in range(min_x, max_x + 1):
			selected_tiles.append(Vector2i(x, y))

	print("Selection start:", selection_start)
	print("Selection end:", selection_end)
	print("Selected tiles:", selected_tiles)

	area_selected.emit()
