extends Entity
class_name EntityWorker

var body : EntityBody
var mind : EntityMind

func setup(my_position : ComponentPosition, ):
	add_component(my_position)
