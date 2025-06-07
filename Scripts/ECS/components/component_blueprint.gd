extends Component
class_name ComponentBlueprint

# speed = meter / second
# more to be used for ~limits of full/partial anatomical capabilities for humans
var min_walk_speed = 0.8
var avg_walk_speed = 1.78
var max_walk_speed = 3.3

var max_hand_walk_speed = 4.0

var max_no_knee_walk_speed = 7.0

var min_crawl_speed = 0.1
var avg_crawl_speed = 0.5
var max_crawl_speed = 1.47


var sixsix_sight = [6,6] # perfect vision at 6 meters ~[6,3] = perfect vision at 12
var max_sight_distance = 32
var min_sight_distance = 0
#var inf_vision = false

#number of locomotive limbs
var pedal = 2

# locomotive body parts or limbs
var leg_count = 2
var wing_count = 0
var wheel_count = 0
var tread_count = 0
var fin_count = 0
var tentical_count = 0
var arm_count = 2

#meters and kg

var max_grown_weight = 100
var min_grown_weight = 55

var max_pube_weight = 62
var min_pube_weight = 28

var max_birth_weight = 4.6
var min_birth_weight = 2.1


var max_grown_height = 2.0
var min_grown_height = 1.5

var max_pube_height = 1.63
var min_pube_height = 1.0

var max_birth_height = 0.55
var min_birth_height = 0.45


var year_one_UARM_max = 0.18
var year_one_UARM_min = 0.13

var max_grown_UARM = 0.37
var min_grown_UARM = 0.22

var min_grown_LARM = 0.17
var max_grown_LARM = 0.34

var min_grown_ULEG = 0.54
var max_grown_ULEG = 0.70

var min_grown_LLEG = 0.25
var max_grown_LLEG = 0.55

var min_grown_TORSO = 0.8
var max_grown_TORSO = 1.34

var min_grown_NECK = 0.36
var max_grown_NECK = 0.66


#var part_shapes := {
	#PartType.HORN : ShapeData.ShapeTypes.CONE,
	#PartType.BEAK : ShapeData.ShapeTypes.CONE,
#}

func rand_grown_height():
	return randf_range(min_grown_height, max_grown_height)

func get_boy_shoe_size(height : float):
	return (height/.053 - 1.33)
	
func get_girl_shoe_size(height : float):
	return (height/0.045 - 1.40)
	

func get_part_shape_args(part_type: BodyData.PartType, height: float) -> Dictionary:
	match part_type:
		BodyData.PartType.HEAD:
			return HEADr_from_height(height)
		BodyData.PartType.NECK:
			return NECK_args_from_height(height)
		BodyData.PartType.SHOULDER:
			return SHOULDERr_from_height(height)
		BodyData.PartType.ARM:
			return UARM_args_from_height(height)
		BodyData.PartType.ELBOW:
			return ELBOWr_from_height(height)
		BodyData.PartType.HAND:
			return HAND_args_from_height(height)
		BodyData.PartType.TORSO:
			return TORSO_args_from_height(height)
		BodyData.PartType.COD:
			return COD_args_from_height(height)
		BodyData.PartType.HIP:
			return HIPr_from_height(height)
		BodyData.PartType.LEG:
			return ULEG_args_from_height(height)
		BodyData.PartType.KNEE:
			return KNEEr_from_height(height)
		BodyData.PartType.FOOT:
			return FOOT_args_from_height(height)
		BodyData.PartType.EYE:
			return EYEr_from_height(height)
		BodyData.PartType.NOSE:
			return NOSE_args_from_height(height)
		BodyData.PartType.HOOF:
			return HOOF_args_from_height(height)
		BodyData.PartType.PAW:
			return PAW_args_from_height(height)
		BodyData.PartType.CLAW:
			return CLAW_args_from_height(height)
		BodyData.PartType.FEETPAD:
			return FEETPAD_args_from_height(height)
		BodyData.PartType.FLIPPER:
			return FLIPPER_args_from_height(height)
		BodyData.PartType.GENITALS:
			return GENITALSr_from_height(height)
		_:
			push_warning("Shape args not implemented for PartType: %s" % str(part_type))
			return {}

#basic conversion for adults
#0.22 = a * 1.5 + b _     0.37 - 0.22
#0.37 = a * 2.0 + b - a = 2.00 - 1.50 = 0.3, b = 0.22 - 0.3 * 1.5 = -0.23
func UARM_args_from_height(height : float) -> Dictionary[String,float]:
	var circ
	if height <= 0.75:
		circ = lerp(0.13, 0.18, (height - 0.45) / (0.75 - 0.45))  # birth to year one
	elif height <= 1.75:
		circ = lerp(0.18, 0.37, (height - 0.75) / (1.75 - 0.75))  # year one to adult
	else:
		circ = 0.3723
	var h = height/8
	return {
		"l" = h,
		"r" = circ/(2*3.14159)
	}
	
func LARM_args_from_height(height : float) -> Dictionary[String,float]:
	var circ
	if height <= 0.75:
		circ = lerp(0.10, 0.14, (height - 0.45) / (0.75 - 0.45))  # estimated
	elif height <= 1.75:
		circ = lerp(0.14, 0.34, (height - 0.75) / (1.75 - 0.75))
	else:
		circ = 0.34
	var h = height/8
	return {
		"l" = h,
		"r" = circ/(2*3.14159)
	}
	
func ULEG_args_from_height(height :float) -> Dictionary[String,float]:
	var circ
	if height <= 0.75:
		circ = lerp(0.25, 0.38, (height - 0.45) / (0.75 - 0.45))  # estimated
	elif height <= 1.75:
		circ = lerp(0.38, 0.70, (height - 0.75) / (1.75 - 0.75))
	else:
		circ = 0.70
	var h = height/8
	return {
		"l" = h,
		"r" = circ/(2*3.14159)
	}
	
func LLEG_args_from_height(height : float) -> Dictionary[String,float]:
	var circ
	if height <= 0.75:
		circ = lerp(0.12, 0.20, (height - 0.45) / (0.75 - 0.45))  # estimated
	elif height <= 1.75:
		circ = lerp(0.20, 0.55, (height - 0.75) / (1.75 - 0.75))
	else:
		circ = 0.55
	var h = (height/16)*3
	return {
		"l" = h,
		"r" = circ/(2*3.14159)
	}
	
func TORSO_args_from_height(height : float) -> Dictionary[String,float]:
	var circ
	if height <= 0.75:
		circ = lerp(0.25, 0.45, (height - 0.45) / (0.75 - 0.45))  # estimated
	elif height <= 1.75:
		circ = lerp(0.45, 1.34, (height - 0.75) / (1.75 - 0.75))
	else:
		circ = 1.34
	var h = (height/8)*2
	return {
		"l" = h,
		"r" = circ/(2*3.14159)
	}

func HEADr_from_height(height : float) -> Dictionary[String,float]:
	return {"r" = ((height/8)/2)}

func NECK_args_from_height(height:float) -> Dictionary[String,float]:
	var h = height/32
	var r = HEADr_from_height(height)["r"]*0.95
	return {
		"h" = h,
		"r" = r
	}

func SHOULDERr_from_height(height : float) -> Dictionary[String,float]:
	return {"r" = (TORSO_args_from_height(height)["r"]-NECK_args_from_height(height)["r"]/2)}
	
func ELBOWr_from_height(height : float) -> Dictionary[String,float]:
	return {"r" = LARM_args_from_height(height)["r"]}
	
func HAND_args_from_height(height : float) -> Dictionary[String,float]:
	var width = LARM_args_from_height(height)["r"]*2
	var tall = (height/32)*3
	var depth = width/4
	return {
		"l" = depth,
		"h" = tall,
		"w" = width
	}
	
func COD_args_from_height(height : float) -> Dictionary[String,float]:
	var cod_height = HEADr_from_height(height)["r"]*2
	var cod_radius = TORSO_args_from_height(height)["r"]
	return {"h" = cod_height, "r" = cod_radius}
	
func HIPr_from_height(height : float) -> Dictionary[String,float]:
	return {"r" = TORSO_args_from_height(height)["r"]/2}
	
func KNEEr_from_height(height : float) -> Dictionary[String,float]:
	return {"r" = LLEG_args_from_height(height)["r"]}
	
func FOOT_args_from_height(height : float) -> Dictionary[String,float]:
	var width = LLEG_args_from_height(height)["r"]*2
	var tall = height/8
	var size = get_boy_shoe_size(height)
	size -= 3.211
	var length = size*0.085
	return {
		"l" = length,
		"h" = tall,
		"w" = width
	}
	
func EYEr_from_height(height : float) -> Dictionary[String,float]:
	return {"r" = HEADr_from_height(height)["r"]*2/5}
	
func NOSE_args_from_height(height : float) -> Dictionary[String,float]:
	var area = pow(EYEr_from_height(height)["r"],2)
	var tall = EYEr_from_height(height)["r"]
	return {"A" = area, "h" = tall}
	
#func WING_from_height(height: float):
# seems wings are usually 2-4 times the height of a creature
	
#func TAIL_from_height(height : float):
# seems tails are maximally height and usually are smaller the larger an animal is

#func FIN_from_height(height : float):
# this seems more species dependent than anatomically/evolutionarily restrained

func HOOF_args_from_height(height : float) -> Dictionary[String,float]:
	var r = LLEG_args_from_height(height)["r"]*0.95
	var h = height/16
	return{
		"r" = r,
		"h" = h
	}

func PAW_args_from_height(height : float) -> Dictionary[String,float]:
	return HAND_args_from_height(height)

func CLAW_args_from_height(height : float) -> Dictionary[String,float]:
	var length = PAW_args_from_height(height)["l"]
	var radius = length/2
	return { "h" = length, "r" = radius}

#func TENTACLE_from_height(height : float):
# tentacle length varies on speciese but may also be an indicator of health
# largely anything with tentacles has longer tentacles than they do a body

func FEETPAD_args_from_height(height : float) -> Dictionary[String,float]:
	var width = HAND_args_from_height(height)["w"]/5
	var length = width
	var depth = width/4
	return{"rx" = width, "ry" = length, "h" = depth}

#func ANTENNA_from_height(height : float):
	#species based ratio

func FLIPPER_args_from_height(height : float) -> Dictionary[String,float]:
	var length_range = (randf_range(0.25,0.33))
	var width_range = randf_range(0.037,0.093)
	var width = height*width_range
	var length = height*length_range
	var depth_range = randf_range(0.20,0.28)
	var depth = length*depth_range
	return {
		"rx" = width,
		"ry" = depth,
		"h" = length
		}

#func SUCKER_from_height(height :float):
#researching this and my brain is going to implode with the ai implying octopi have arms and not tentacles
#and its like okay but those arms dont have elbows or shoulders or bones so like
#thats a tentacle come on dont fuck with my head like this

func GENITALSr_from_height(height : float) -> Dictionary[String,float]:
	return {"r" = randf_range(0.01, 0.37)}

#fuck horns and beaks im tired of writing these
	
#mac to height conversion: 0.1 height = 0.03 MAC
#FARM to height conversion: 0.5 height = 0.17 FARM
func get_part_height_ratio(part : EntityBodyPart):
	match part.get_type():
		BodyData.PartType.HEAD, BodyData.PartType.FOOT, BodyData.PartType.HIP, BodyData.PartType.COD:
			return 0.125
		BodyData.PartType.NECK, BodyData.PartType.SHOULDER, BodyData.PartType.LEG, BodyData.PartType.ARM:
			return 0.125
		BodyData.PartType.TORSO:
			return 0.25
		BodyData.PartType.HAND:
			return 0.09375
	
#knees = 1/8th
#lower legs = 3/16th
#feet (~ankles) = 1/16th

var peak_height_velocity_duration_range = [24,36] #(months)

var puberty_age_range = [11,21]

# 		head - brain, eyes, ears, tongue, nose, 
# 		neck
# shdr| Torso | shdr\
# arm | torso | arm |
# elb | torso | arm |-middle
# arm | torso | arm |
# hnd | Cod   | hnd /
# hip |       | hip \
# leg |       | leg |
# kne |       | kne |-lower
# leg |       | leg |
# fot |       | fot /
#left | middle| right

func _init():
	comp_name = "blueprint"
	
