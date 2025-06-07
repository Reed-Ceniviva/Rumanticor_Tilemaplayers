extends Entity
class_name EntityWorker

var body : EntityBody
var mind : EntityMind

func setup(my_position : ComponentPosition, my_body : EntityBody):
	add_component(my_position)
	var growth_comp = ComponentGrowth.new()
	growth_comp.standing_growth = 0.08
	body = my_body
	body.add_component(growth_comp)
