extends Component
class_name ComponentMobile

var mobile_parts : Array[ComponentBodyPart]

var possible_move_actions = []
var structured_limbs : Dictionary [String,Array] = {"Leg" : []}


func _init(mobile_body : EntityBody, char_blueprint : ComponentBlueprint):
	comp_name = "mobile"
	
	pass


#func _init_bad(mobile_body_parts : Array[ComponentBodyPart], char_blueprint : ComponentBlueprint):
	#comp_name = "mobile"
	#mobile_parts = mobile_body_parts
	#var body_actions
	#
	#
	#for mobile_body_part in mobile_body_parts:
		##check for full leg
		#if mobile_body_part.type == mobile_body_part.PartType.HIP:
			#var hip_connected_parts: Dictionary[int,ComponentBodyPart] = mobile_body_part.get_all_parts()
			#for hip_part_id in hip_connected_parts:
				#if hip_connected_parts[hip_part_id].type == mobile_body_part.PartType.LEG:
					#var temp_leg = mobile_body_part.get_part_flat(hip_part_id)
					#var leg_connected_parts: Dictionary[int,ComponentBodyPart] = temp_leg.get_all_parts()
					#for leg_part_id in leg_connected_parts:
						#if leg_connected_parts[leg_part_id].type == mobile_body_part.PartType.KNEE:
							#var temp_knee = temp_leg.get_part_flat(leg_part_id)
							#if temp_knee.parent_part.type == temp_knee.PartType.LEG:
							#
								#structured_limbs[mobile_body_part.PartSide.get(mobile_body_part.side, "")  + " Leg"].append(mobile_body_part.part_id)
					#else:
						#structured_limbs["Crippled_Leg_Foot"].append(mobile_body_part.part_id)
				#else:
					#structured_limbs["Crippled_Leg_Knee"].append(mobile_body_part.part_id)
			##else: unstructured limb ~ stand alone hip
			#
		#if mobile_body_part.type == mobile_body_part.PartType.ABMUSCLES:
			#possible_move_actions.append(mobile_body_part.BodyActions.SLITHER)
			#
		##really i should be getting the arm and checking if it has the elbow and hand but this works for now
		#if mobile_body_part.type == mobile_body_part.PartType.SHOULDER:
			#var shoulder_connected_parts = mobile_body_part.get_all_parts().values()
			#if shoulder_connected_parts.has(mobile_body_part.PartType.ARM):
				#if shoulder_connected_parts.has(mobile_body_part.PartType.ELBOW):
					#if shoulder_connected_parts.has(mobile_body_part.PartType.HAND):
						#possible_move_actions.append(mobile_body_part.BodyActions.CRAWL)
						#possible_move_actions.append(mobile_body_part.BodyActions.GRAB)
						#structured_limbs["Arm"].append(mobile_body_part.part_id)
					#else:
						#structured_limbs["Crippled_Arm_Hand"].append(mobile_body_part.part_id)
				#else:
					#structured_limbs["Crippled_Arm_Elbow"].append(mobile_body_part.part_id)
			#
		#
	#if structured_limbs["Leg"].size() == 0:
		#pass
	#
	#if structured_limbs["Leg"].size() >= 2 and char_blueprint.num_walking_limbs >= 2:
		#body_actions = mobile_parts[0].BodyActions
		#possible_move_actions.append(body_actions.WALK)
		#possible_move_actions.append(body_actions.RUN)
		#possible_move_actions.append(body_actions.LIMP)
		#possible_move_actions.append(body_actions.JUMP)
		#possible_move_actions.append(body_actions.HOP)
		#possible_move_actions.append(body_actions.KICK)
				#
	#var crippled_legs = 0
	#for key in structured_limbs.keys():
		#body_actions = mobile_parts[0].BodyActions
		#if key.has("Crippled_Leg"):
			#crippled_legs += 1
	#if crippled_legs > structured_limbs["Leg"]:
		#possible_move_actions.erase(body_actions.WALK)
		#possible_move_actions.erase(body_actions.RUN)
		#possible_move_actions.erase(body_actions.JUMP)
			#
func structured_limbs_get(part_group:String) -> Array[int]:
	var result : Array[int]
	for limb_type in structured_limbs:
		if limb_type.contains(part_group):
			result.append()
