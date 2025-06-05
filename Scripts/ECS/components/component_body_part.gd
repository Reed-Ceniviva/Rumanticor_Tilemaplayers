# component_body_part.gd
extends Component
class_name ComponentBodyPart

var part_type: BodyData.PartType
var parent: EntityBodyPart = null
var children: Array[EntityBodyPart] = []
var side: BodyData.PartSide = BodyData.PartSide.ALL
var face: BodyData.PartFace = BodyData.PartFace.ALL

func _init(parttype : BodyData.PartType):
	comp_name = "bodypart"
	part_type = parttype

func add_child(part: EntityBodyPart):
	#if _has_loop(part):
		#push_error("Loop detected: cannot add part as child of itself or its descendant.")
		#return
	children.append(part)

func _has_loop(part: EntityBodyPart) -> bool:
	var current = self
	while current != null:
		if current == part:
			return true
		current = current.parent
	return false
