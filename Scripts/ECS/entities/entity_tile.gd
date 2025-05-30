class_name EntityTile
extends Entity  # Or use Resource if you're not instancing into the scene

var elevation: float
var my_position : ComponentPosition

func _init(pos : Vector2i, _elevation : float):
	my_position = ComponentPosition.new(pos)
	elevation = _elevation
	
func get_elevation():
	return elevation
