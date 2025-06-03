# entity_body_part.gd
extends Entity
class_name EntityBodyPart

const BodyData = preload("uid://rhetoeckohcj")
var _BodyData : BodyData

const ShapeData = preload("uid://c3aevfujto4dy")
var _ShapeData : ShapeData

var coating : BodyData.PartType
@export var component: ComponentBodyPart
var shape : ComponentShape

func _init(part_comp : ComponentBodyPart):
	_BodyData = BodyData.new()
	component = part_comp
	if _BodyData.part_shapes.has(get_type()):
		var shape_type = _BodyData.part_shapes[get_type()]
		shape = ComponentShape.new(shape_type)

func get_type() -> BodyData.PartType:
	return component.part_type

func get_side() -> BodyData.PartSide:
	return component.side

func get_child_parts() -> Array[EntityBodyPart]:
	return component.children

func get_parent_part() -> EntityBodyPart:
	return component.parent
	
func has_child_part(part_type : BodyData.PartType) -> EntityBodyPart:
	for child in component.children:
		if child.component.part_type == part_type:
			return child
	return null
	
func match_type_child_part(part_type : BodyData.PartType) -> Array[EntityBodyPart]:
	var matching_parts = []
	for child in component.children:
		if child.component.part_type == part_type:
			matching_parts.append(child)
	return matching_parts

func add_child_part(part: EntityBodyPart):
	if not _BodyData.valid_connection(self.get_type(), part.get_type()):
		push_error("Invalid connection from %s to %s" % [str(self.get_type()), str(part.get_type())])
		return
	component.add_child(part)
