extends Component
class_name ComponentMobile

var mobile_parts : Array[ComponentBodyPart]

var possible_move_actions = []
var structured_limbs : Dictionary [String,int] = {"Leg" : 0}

func _init(mobile_body_parts : Array[ComponentBodyPart], char_blueprint : ComponentBlueprint):
	comp_name = "mobile"
	mobile_parts = mobile_body_parts
	var body_actions
	#should be using more local data as i check deeper in the body nest
	for mobile_body_part in mobile_body_parts:
		if mobile_body_part.type == mobile_body_part.PartType.HIP:
			var hip_connected_parts = mobile_body_part.get_all_parts().values()
			if hip_connected_parts.has(mobile_body_part.PartType.LEG):
				if hip_connected_parts.has(mobile_body_part.PartType.KNEE):
					if hip_connected_parts.has(mobile_body_part.PartType.FOOT):
						structured_limbs["Leg"] += 1
					else:
						structured_limbs["Crippled_Leg_Foot"] += 1
				else:
					structured_limbs["Crippled_Leg_Knee"] += 1
			#else: unstructured limb ~ stand alone hip
			
		if mobile_body_part.type == mobile_body_part.PartType.ABMUSCLES:
			possible_move_actions.append(mobile_body_part.BodyActions.SLITHER)
			
		#really i should be getting the arm and checking if it has the elbow and hand but this works for now
		if mobile_body_part.type == mobile_body_part.PartType.SHOULDER:
			var shoulder_connected_parts = mobile_body_part.get_all_parts().values()
			if shoulder_connected_parts.has(mobile_body_part.PartType.ARM):
				if shoulder_connected_parts.has(mobile_body_part.PartType.ELBOW):
					if shoulder_connected_parts.has(mobile_body_part.PartType.HAND):
						possible_move_actions.append(mobile_body_part.BodyActions.CRAWL)
						possible_move_actions.append(mobile_body_part.BodyActions.GRAB)
						structured_limbs["Arm"] += 1
					else:
						structured_limbs["Crippled_Arm_Hand"] += 1
				else:
					structured_limbs["Crippled_Arm_Elbow"] += 1
			
		
	if structured_limbs["Leg"] == 0:
		pass
	
	if structured_limbs["Leg"] >= 2 and char_blueprint.num_walking_limbs >= 2:
		body_actions = mobile_parts[0].BodyActions
		possible_move_actions.append(body_actions.WALK)
		possible_move_actions.append(body_actions.RUN)
		possible_move_actions.append(body_actions.LIMP)
		possible_move_actions.append(body_actions.JUMP)
		possible_move_actions.append(body_actions.HOP)
		possible_move_actions.append(body_actions.KICK)
				
	var crippled_legs = 0
	for key in structured_limbs.keys():
		body_actions = mobile_parts[0].BodyActions
		if key.has("Crippled_Leg"):
			crippled_legs += 1
	if crippled_legs > structured_limbs["Leg"]:
		possible_move_actions.erase(body_actions.WALK)
		possible_move_actions.erase(body_actions.RUN)
		possible_move_actions.erase(body_actions.JUMP)
			
