extends Entity
class_name EntityMind

var my_body : EntityBody
var has_brain = false
var my_BodyData

func _init(body : EntityBody):
	my_BodyData = BodyData.new()
	my_body = body
	var head_parts = my_body.root_part.get_child_parts()
	if my_body.root_part.has_child_part(BodyData.PartType.BRAIN):
		has_brain = true
	if my_body.root_part.has_child_part(BodyData.PartType.EYE):
		var eye_parts : Array[EntityBodyPart] = my_body.root_part.match_type_child_part(BodyData.PartType.EYE)
		var left_eyes = 0
		var right_eyes = 0
		var center_eyes = 0
		for eye_part in eye_parts:
			if eye_part.get_side() == BodyData.PartSide.RIGHT:
				right_eyes +=1
			elif eye_part.get_side() == BodyData.PartSide.LEFT:
				left_eyes += 1
			elif eye_part.get_side() == BodyData.PartSide.CENTER:
				center_eyes += 1
		var total_eyes = left_eyes+right_eyes+center_eyes
		if total_eyes > 0:
			#
			pass
		if left_eyes > 0 and right_eyes > 0:
			#stereo vision ~ depth perception ~ better judge of distance
			#each eye provides vision of distance but having stereo vision enhances the overall ability of depth perception
			#this increased depth perception is decreased over distance 
			pass
	my_body.update_connection_data()
	var limb_data = my_BodyData.count_limb_sequences(my_body.connection_data)
	
