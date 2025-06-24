extends ColorRect

@export var tile_size = 16
@onready var camera = get_viewport().get_camera_2d()


var is_selecting := false
var selection_start := Vector2i()
var selection_end := Vector2i()
var selected_tiles : Array[Vector2i] = []

signal area_selected

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				is_selecting = true
				selection_start = world_to_map(get_global_mouse_position())
				selection_end = selection_start
			else:
				is_selecting = false
				process_selection()
	elif event is InputEventMouseMotion and is_selecting:
		selection_end = world_to_map(get_global_mouse_position())

func world_to_map(world_pos: Vector2) -> Vector2i:
	if not tile_size:
		tile_size = 16
	return Vector2i(floor(world_pos.x / tile_size), floor(world_pos.y / tile_size))

func _draw():
	if is_selecting:
		var rect = Rect2(selection_start * tile_size, (selection_end - selection_start + Vector2i(1,1)) * tile_size)
		draw_rect(rect.abs(), Color(0, 1, 0, 0.3), true) # Green semi-transparent fill
		draw_rect(rect.abs(), Color(0, 1, 0), false)     # Green border

func _process(_delta):
	#position = camera.position
	queue_redraw() # Continuously redraw selection

func process_selection():
	selected_tiles.clear()
	var min_x = min(selection_start.x, selection_end.x)
	var max_x = max(selection_start.x, selection_end.x)
	var min_y = min(selection_start.y, selection_end.y)
	var max_y = max(selection_start.y, selection_end.y)
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			selected_tiles.append(Vector2i(x, y))
	print("Selected area:", selected_tiles)
	area_selected.emit()
