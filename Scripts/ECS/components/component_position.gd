extends Component  # Or any base if you're using a custom component base class
class_name ComponentPosition

# 2D grid position (integer coordinates)
var my_position: Vector2i = Vector2i.ZERO

func _init(pos: Vector2i = Vector2i.ZERO):
	my_position = pos
	comp_name = ("position")
	
