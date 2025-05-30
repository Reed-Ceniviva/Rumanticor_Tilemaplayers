class_name ComponentBodyPart
extends Component

const BodyData = preload("uid://rhetoeckohcj")
	
var part_type: BodyData.PartType # e.g., "brain", "leg", "torso"
var is_critical: bool = false # Brain, heart, etc.
var parent_id : int
var child_ids : Array[int]
var my_body : Entity = null

func _init(_part_type : BodyData.PartType):
	part_type = _part_type
	comp_name = "bodypart"
