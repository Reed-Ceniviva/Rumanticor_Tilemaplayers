class_name EntityTile
extends EntityBase  # Or use Resource if you're not instancing into the scene

var elevation: float
var my_position : ComponentPosition
var entities : Dictionary[int, EntityBase]

func _init(pos : Vector2i, _elevation : float):
	my_position = ComponentPosition.new(pos)
	elevation = _elevation
	entities = {}
