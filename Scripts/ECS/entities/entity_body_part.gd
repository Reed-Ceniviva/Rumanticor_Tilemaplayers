# entity_body_part.gd
extends Entity
class_name EntityBodyPart

const BodyData = preload("uid://rhetoeckohcj")
var _BodyData : BodyData

const ShapeData = preload("uid://c3aevfujto4dy")
var _ShapeData : ShapeData

var coating : BodyData.PartType
@export var component: ComponentBodyPart

func _init(part_comp : ComponentBodyPart):
	_BodyData = BodyData.new()
	component = part_comp
	add_component(part_comp)
	if _BodyData.part_shapes.has(get_type()):
		var shape_type = _BodyData.part_shapes[get_type()]
		var shape = ComponentShape.new(shape_type)
		add_component(shape)
	if part_comp.part_type == BodyData.PartType.STOMACH:
		var cont_comp = ComponentContainer.new(0.004)
		cont_comp.mode = null # treats everything eaten as a liquid 
		add_component(cont_comp)
		

func get_type() -> BodyData.PartType:
	return get_component("bodypart").part_type

func get_side() -> BodyData.PartSide:
	return get_component("bodypart").side

func get_child_parts() -> Array[EntityBodyPart]:
	return get_component("bodypart").children

func get_parent_part() -> EntityBodyPart:
	return get_component("bodypart").parent
	
func set_shape_args(args : Dictionary):
	if has_component("shape") != null:
		get_component("shape").shape_args = args
	else:
		print("part has no shape")

func has_child_part(part_type : BodyData.PartType) -> EntityBodyPart:
	for child in get_component("bodypart").children:
		if child.get_component("bodypart").part_type == part_type:
			return child
	return null
	
func match_type_child_part(part_type : BodyData.PartType) -> Array[EntityBodyPart]:
	var matching_parts = []
	for child in get_component("bodypart").children:
		if child.get_component("bodypart").part_type == part_type:
			matching_parts.append(child)
	return matching_parts

func add_child_part(part: EntityBodyPart):
	if not _BodyData.valid_connection(self.get_type(), part.get_type()):
		push_error("Invalid connection from %s to %s" % [str(self.get_type()), str(part.get_type())])
		return
	get_component("bodypart").add_child(part)
	part.get_component("bodypart").parent = self
