extends System
class_name SystemBodies

@onready var wm = $"../.."

@onready var _ShapeData = ShapeData.new() 
@onready var _BodyData = BodyData.new()

#func get_total_weight(body: ComponentBody) -> float:
	#var total := 0.0
	#for part in body.root_parts:
		#total += _get_part_weight_recursive(part)
	#return total
#
#func _get_part_weight_recursive(part: Entity) -> float:
	#var material = part.get_component("material")
	#var shape = part.get_component("shape")
	#if not material or not shape:
		#return 0.0
	#
	#var shape_type = shape.shape_type
	#var args = shape.get_volume_args()
	#var volume = _ShapeData.get_volume(shape_type, args)
	#var weight = volume * material.density
	#
	#var part_comp = part.get_component("body_part")
	#if part_comp:
		#for child in part_comp.children:
			#weight += _get_part_weight_recursive(child)
	#
	#return weight

func create_part(part_type : BodyData.PartType, parent : EntityBodyPart = null, part_side : BodyData.PartSide = BodyData.PartSide.ALL, part_face : BodyData.PartFace = BodyData.PartFace.ALL) -> EntityBodyPart:
	var part =  EntityBodyPart.new(create_part_comp(part_type,parent,part_side,part_face))
	wm.new_entity_id(part)
	if parent:
		parent.add_child_part(part)
	return part

func set_body_shape_args(body : EntityBody , blueprint : ComponentBlueprint):
	var parts = body.get_all_parts()
	for part in parts:
		if part.has_component("shape"):
			part.get_component("shape").set_args(blueprint.get_part_shape_args(part.get_type(), body.height))

func create_part_comp(part_type : BodyData.PartType, parent : EntityBodyPart = null, part_side : BodyData.PartSide = BodyData.PartSide.ALL, part_face : BodyData.PartFace = BodyData.PartFace.ALL) -> ComponentBodyPart:
	var component = ComponentBodyPart.new(part_type)
	component.parent = parent
	component.side = part_side
	component.face = part_face
	return component
	
func build_limb(sequence: Array, base_part: EntityBodyPart, side: BodyData.PartSide) -> void:
	var current_parent = base_part
	for part_type in sequence:
		var part = create_part(part_type, current_parent, side)
		current_parent = part

func build_symetrical_head(eyes : int = 2 , ears : int = 2, noses : int = 1, mouths : int = 1) -> EntityBodyPart:
	var head = create_part(BodyData.PartType.HEAD)
	if eyes > 1:
		for i in range(eyes/2):
			#create right eyes
			create_part(BodyData.PartType.EYE, head, BodyData.PartSide.RIGHT, BodyData.PartFace.FRONT)
		for i in range(eyes - eyes/2):
			#create left eyes
			create_part(BodyData.PartType.EYE, head, BodyData.PartSide.LEFT, BodyData.PartFace.FRONT)
	elif eyes == 1:
		create_part(BodyData.PartType.EYE, head, BodyData.PartSide.CENTER, BodyData.PartFace.FRONT)
	if ears > 1:
		for i in range(ears/2):
			#create right eyes
			create_part(BodyData.PartType.EAR, head, BodyData.PartSide.RIGHT)
		for i in range(ears - ears/2):
			#create left eyes
			create_part(BodyData.PartType.EAR, head, BodyData.PartSide.LEFT)
	elif ears == 1:
		create_part(BodyData.PartType.EAR, head, BodyData.PartSide.CENTER)
	if noses > 1:
		for i in range(noses/2):
			#create right nose
			create_part(BodyData.PartType.NOSE, head, BodyData.PartSide.RIGHT, BodyData.PartFace.FRONT)
		for i in range(noses - noses/2):
			#create right nose
			create_part(BodyData.PartType.NOSE, head, BodyData.PartSide.LEFT, BodyData.PartFace.FRONT)
	elif noses == 1:
		create_part(BodyData.PartType.NOSE, head, BodyData.PartSide.LEFT, BodyData.PartFace.FRONT)
	if mouths > 1:
		for i in range(mouths/2):
			#create right nose
			create_part(BodyData.PartType.MOUTH, head, BodyData.PartSide.RIGHT, BodyData.PartFace.FRONT)
		for i in range(mouths - mouths/2):
			#create right nose
			create_part(BodyData.PartType.MOUTH, head, BodyData.PartSide.LEFT, BodyData.PartFace.FRONT)
	elif mouths == 1:
		create_part(BodyData.PartType.MOUTH, head, BodyData.PartSide.CENTER, BodyData.PartFace.FRONT)
	var hair = create_part(BodyData.PartType.HAIR, head)
	var brain = create_part(BodyData.PartType.BRAIN, head)
	return head
	
func build_symetrical_torso(arms : int=2, legs: int=2, tails: int=0, wings: int =0) -> EntityBodyPart:
	var _BodyData = BodyData.new()
	var torso = create_part(BodyData.PartType.TORSO)
	if arms > 1:
		for i in range(arms/2):
			#create right arm(s)
			build_limb(_BodyData.person_arm_sequence, torso,BodyData.PartSide.RIGHT)
		for i in range(arms - arms/2):
			#create left arm(s)
			build_limb(_BodyData.person_arm_sequence, torso,BodyData.PartSide.LEFT)
	elif arms == 1:
		build_limb(_BodyData.person_arm_sequence, torso,BodyData.PartSide.CENTER)
	if legs > 1:
		for i in range(legs/2):
			#create right leg(s)
			build_limb(_BodyData.person_leg_sequence, torso,BodyData.PartSide.RIGHT)
		for i in range(legs - legs/2):
			#create left leg(s)
			build_limb(_BodyData.person_leg_sequence, torso,BodyData.PartSide.LEFT)
	elif legs == 1:
		build_limb(_BodyData.person_leg_sequence, torso,BodyData.PartSide.CENTER)
	if wings > 1:
		for i in range(wings/2):
			#create right wing(s)
			create_part(BodyData.PartType.WING, torso, BodyData.PartSide.RIGHT, BodyData.PartFace.BACK)
		for i in range(wings - wings/2):
			#create left wing(s)
			create_part(BodyData.PartType.WING, torso, BodyData.PartSide.LEFT, BodyData.PartFace.BACK)
	elif wings == 1:
		create_part(BodyData.PartType.WING, torso, BodyData.PartSide.CENTER, BodyData.PartFace.BACK)
	if tails > 1:
		for i in range(tails/2):
			#create right wing(s)
			create_part(BodyData.PartType.TAIL, torso, BodyData.PartSide.RIGHT, BodyData.PartFace.BACK)
		for i in range(tails - tails/2):
			#create left wing(s)
			create_part(BodyData.PartType.TAIL, torso, BodyData.PartSide.LEFT, BodyData.PartFace.BACK)
	elif tails == 1:
		create_part(BodyData.PartType.TAIL, torso, BodyData.PartSide.CENTER, BodyData.PartFace.BACK)
	return torso

func connect_head_to_torso(head : EntityBodyPart, torso : EntityBodyPart) -> EntityBody:
	var body = EntityBody.new()
	wm.new_entity_id(body)
	var neck = create_part(BodyData.PartType.NECK, head)
	var spine = create_part(BodyData.PartType.SPINE,neck, BodyData.PartSide.CENTER, BodyData.PartFace.BACK)
	torso.get_component("bodypart").parent = spine
	body.root_part = head	
	return body
	
func add_coating(body : EntityBody ,coating_type : BodyData.PartType = BodyData.PartType.SKIN):
	body.coating = coating_type
	for part in body.get_all_parts():
		if _BodyData.part_traits[part.get_type()].has("is_coated"):
			if _BodyData.part_traits[part.get_type()]["is_coated"] == true:
				part.coating = coating_type

func build_base_person_body() -> EntityBody:
	var body = connect_head_to_torso(build_symetrical_head(),build_symetrical_torso())
	var blueprint = ComponentBlueprint.new()
	body.height = blueprint.rand_grown_height()
	set_body_shape_args(body, blueprint)
	add_coating(body)
	return body
