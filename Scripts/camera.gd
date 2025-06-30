extends Camera2D

var zoomSpeed: float = 0.05
var zoomMin: float = 0.001
var zoomMax: float = 2.0
var dragSensitivity: float = 1.0
var pos_change : Vector2 = Vector2.ZERO


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pos_change -= event.relative * dragSensitivity / zoom
		if abs(pos_change.x) >= 16:
			position.x += pos_change.x
			pos_change.x = Vector2.ZERO.x
		if abs(pos_change.y) >= 16:
			position.y += pos_change.y
			pos_change.y = Vector2.ZERO.y
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoomSpeed, zoomSpeed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoomSpeed,zoomSpeed)
		zoom = clamp(zoom, Vector2(zoomMin,zoomMin), Vector2(zoomMax,zoomMax))
