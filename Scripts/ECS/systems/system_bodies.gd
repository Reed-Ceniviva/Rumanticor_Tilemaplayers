extends System
class_name SystemBodies

@onready var _ShapeData = ShapeData.new() 

func get_total_weight(body: ComponentBody) -> float:
	var total := 0.0
	for part in body.root_parts:
		total += _get_part_weight_recursive(part)
	return total

func _get_part_weight_recursive(part: Entity) -> float:
	var material = part.get_component("material")
	var shape = part.get_component("shape")
	if not material or not shape:
		return 0.0
	
	var shape_type = shape.shape_type
	var args = shape.get_volume_args()
	var volume = _ShapeData.get_volume(shape_type, args)
	var weight = volume * material.density
	
	var part_comp = part.get_component("body_part")
	if part_comp:
		for child in part_comp.children:
			weight += _get_part_weight_recursive(child)
	
	return weight
