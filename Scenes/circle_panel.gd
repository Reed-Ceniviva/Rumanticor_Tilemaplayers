extends Panel

@export var radius: float = 100.0

func _ready():
	var parent = get_parent_control()
	var children = get_children()
	var count = children.size()
	for i in range(count):
		var angle = i * TAU / count  # TAU is 2π
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		var child = children[i]

		# Center each child around the middle of this control
		if child is Control:
			print(size)
			child.position = Vector2(x, y) + get_rect().size / 2.0 - child.get_rect().size / 2.0
