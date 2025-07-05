extends Resource
class_name BodyData

enum PartType {
	HEAD, NECK, SPINE, SHOULDER, ARM, ELBOW, HAND, TORSO, COD, HIP, LEG, KNEE, FOOT,
	TAIL, EYE, NOSE, EAR, TONGUE, WING, FIN, HOOF, PAW, CLAW, TENTACLE, ABMUSCLES,
	FEETPAD, SKIN, WHISKER, ANTENNA, JACOBSON, LATERALLINE, ELECTRORECEPTOR, FLIPPER,
	PIT, TYMPANUM, LABIALPALP, BRAIN, HAIR, SUCKER, GENITALS, MOUTH, HORN, SCALES, PELT, COATING,
	BEAK, STOMACH
} 

var part_shapes := {
	PartType.HEAD : ShapeData.ShapeTypes.SPHERE,
	PartType.NECK : ShapeData.ShapeTypes.CYLINDER,
	PartType.SHOULDER : ShapeData.ShapeTypes.SPHERE,
	PartType.ARM : ShapeData.ShapeTypes.CYLINDER,
	PartType.ELBOW : ShapeData.ShapeTypes.SPHERE,
	PartType.HAND : ShapeData.ShapeTypes.CUBOID,
	PartType.TORSO : ShapeData.ShapeTypes.CYLINDER,
	PartType.COD : ShapeData.ShapeTypes.CONE,
	PartType.HIP : ShapeData.ShapeTypes.SPHERE,
	PartType.LEG : ShapeData.ShapeTypes.CYLINDER,
	PartType.KNEE : ShapeData.ShapeTypes.SPHERE,
	PartType.FOOT : ShapeData.ShapeTypes.CUBOID,
	PartType.TAIL : ShapeData.ShapeTypes.CONE,
	PartType.EYE : ShapeData.ShapeTypes.SPHERE,
	PartType.NOSE : ShapeData.ShapeTypes.PYRAMID,
	PartType.WING : ShapeData.ShapeTypes.ELLIPSOID,
	PartType.FIN : ShapeData.ShapeTypes.ELLIPSOID,
	PartType.HOOF : ShapeData.ShapeTypes.CYLINDER,
	PartType.PAW : ShapeData.ShapeTypes.CUBOID,
	PartType.CLAW : ShapeData.ShapeTypes.CONE,
	PartType.TENTACLE : ShapeData.ShapeTypes.CONE,
	PartType.FEETPAD : ShapeData.ShapeTypes.ELLIPSOID,
	PartType.ANTENNA : ShapeData.ShapeTypes.CONE,
	PartType.FLIPPER : ShapeData.ShapeTypes.ELLIPSOID,
	PartType.SUCKER : ShapeData.ShapeTypes.SPHERE,
	PartType.GENITALS : ShapeData.ShapeTypes.SPHERE,
	PartType.HORN : ShapeData.ShapeTypes.CONE,
	PartType.BEAK : ShapeData.ShapeTypes.CONE
}

enum BodyActions {
WALK, RUN, JUMP,  CLIMB,  CRAWL, ROLL, SPRINT, LIMP, DRAG, HANDRUN, SLITHER, FLY,
LOOK, SENSE, HEAR, TASTE, SMELL, FEEL, 
SWING, AIM, KICK, GRIP, THROW, LOB ,
SUCK, BLOW, JERK, PECK, EAT, DRINK, SHAKE
}

enum PartSide {LEFT, CENTER, RIGHT, ALL}
enum PartLevel {LOWER, MIDDLE, UPPER, HEAD, ALL}
enum PartFace {FRONT, BACK, ALL}

var part_traits := {
	PartType.LEG: 	{mobile=true, joint=false, limb=true, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.KNEE: 	{mobile=true, joint=true, limb=false, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.HIP: 	{mobile=true, joint=true, limb=false, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.FOOT: 	{mobile=true, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.HOOF: 	{mobile=true, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.PAW: 	{mobile=true, joint=true, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.TENTACLE: {mobile=true, joint=false, limb=true, extremity=false, organ=false, sensory=true, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.ABMUSCLES: {mobile=true, joint=true, limb=false, extremity=false, organ=true, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.FEETPAD: {mobile=true, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.WING: 	{mobile=true, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.FIN: 	{mobile=true, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.FLIPPER:  {mobile=true, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.ARM: 	{mobile=true, joint=false, limb=true, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.SHOULDER: {mobile=true, joint=true, limb=false, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.HAND: 	{mobile=true, joint=true, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.ELBOW: {mobile=true, joint=true, limb=false, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.NECK: 	{mobile=false, joint=true, limb=false, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.COD: 	{mobile=false, joint=false, limb=true, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.HORN: 	{mobile=false, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.GENITALS: {mobile=false, joint=false, limb=false, extremity=true, organ=true, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.SUCKER:{mobile=false, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=true, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.HAIR: 	{mobile=false, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.HEAD: 	{mobile=false, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.TAIL: 	{mobile=false, joint=false, limb=false, extremity=true, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.MOUTH: {mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.BRAIN: {mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.PIT: 	{mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=true, vision=true, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.LATERALLINE: {mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=true, vision=false, touch=false, smell=false, taste=false, field=true, bone=false, coating=false},
	PartType.TONGUE: {mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=false, vision=false, touch=false, smell=false, taste=true, field=false, bone=false, coating=false},
	PartType.EAR: 	{mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=true, vision=false, touch=false, smell=false, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.NOSE: 	{mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=true, vision=false, touch=false, smell=true, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.EYE: 	{mobile=false, joint=false, limb=false, extremity=false, organ=true, sensory=true, vision=true, touch=false, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.WHISKER: {mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=true, smell=false, taste=false, field=false, bone=false, coating=false},
	PartType.ANTENNA: {mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=true, smell=true, taste=false, field=false, bone=false, coating=false, is_coated=true},
	PartType.JACOBSON: {mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=false, smell=true, taste=false, field=false, bone=false, coating=false},
	PartType.ELECTRORECEPTOR: {mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=false, smell=false, taste=false, field=true, bone=false, coating=false},
	PartType.TYMPANUM: {mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=false, smell=false, taste=false, field=true, bone=false, coating=false},
	PartType.LABIALPALP: {mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=true, smell=false, taste=true, field=false, bone=false, coating=false},
	PartType.SPINE: {mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=false, vision=false, touch=false, smell=false, taste=false, field=false, bone=true, coating=false},
	PartType.SKIN: 	{mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=true, smell=false, taste=false, field=false, bone=false, coating=true},
	PartType.SCALES:{mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=true, smell=false, taste=false, field=false, bone=false, coating=true},
	PartType.PELT: 	{mobile=false, joint=false, limb=false, extremity=false, organ=false, sensory=true, vision=false, touch=true, smell=false, taste=false, field=false, bone=false, coating=true},
	PartType.STOMACH:{organ=true,coating=false,is_coated=false},
	PartType.BEAK: {extremity = true, sensory = true, touch = true, bone = true, coating = false, is_coated = false}
}


enum BodyTypes {
	BIPEDAL, QUADROPED, SECTOPED, OCTOPED
}

enum PersonTypes {
	HUMAN, ELF, DWARF, GOBLIN
}

var person_leg_sequence = [PartType.HIP, PartType.LEG, PartType.KNEE, PartType.LEG, PartType.FOOT]
var person_arm_sequence = [PartType.SHOULDER, PartType.ARM, PartType.ELBOW, PartType.ARM, PartType.HAND]
#var arm_start_sequence = [PartType.SHOULDER, PartType.ARM]
#var arm_joint_sequence = [PartType.ARM, PartType.ELBOW, PartType.ARM]
#var arm_end_sequences = [[PartType.ARM, PartType.HAND], [PartType.ARM, PartType.PAW],[PartType.ARM, PartType.HOOF]]
#var leg_start_sequence = [PartType.HIP, PartType.LEG]
#var leg_joint_sequence = [PartType.LEG, PartType.KNEE, PartType.LEG]
#var leg_end_sequences = [[PartType.LEG, PartType.FOOT], [PartType.LEG, PartType.PAW],[PartType.LEG, PartType.HOOF]]
#var mobile_limb = [[is_mobile,is_joint],[is_mobile,is_limb],[is_mobile,is_joint], [is_mobile, is_limb], [is_mobile, is_extremity]]


var valid_connections := {
	PartType.HEAD: [
		PartType.EYE, PartType.NOSE, PartType.EAR, PartType.MOUTH,
		PartType.WHISKER, PartType.ANTENNA, PartType.JACOBSON, PartType.TYMPANUM,
		PartType.LABIALPALP, PartType.HAIR, PartType.BRAIN,
		PartType.PIT, PartType.LATERALLINE, PartType.ELECTRORECEPTOR,
		PartType.NECK, PartType.HORN, PartType.BEAK
	],
	PartType.NECK: [PartType.SPINE],
	PartType.SPINE: [PartType.TORSO],
	PartType.TORSO: [PartType.HIP, PartType.SHOULDER, PartType.COD, PartType.TAIL, PartType.ABMUSCLES, PartType.WING, PartType.FIN, PartType.FLIPPER, PartType.STOMACH],
	PartType.SHOULDER: [PartType.ARM],
	PartType.COD: [PartType.GENITALS],
	PartType.HIP: [PartType.LEG],
	PartType.LEG: [PartType.KNEE, PartType.FOOT, PartType.LEG, PartType.HOOF, PartType.PAW, PartType.HAND],
	PartType.KNEE: [PartType.LEG],
	PartType.FOOT: [PartType.FEETPAD],
	PartType.HOOF: [],
	PartType.ABMUSCLES: [],
	PartType.ARM: [PartType.ELBOW, PartType.HAND, PartType.ARM, PartType.HOOF, PartType.PAW],
	PartType.ELBOW: [PartType.ARM],
	PartType.HAND: [PartType.CLAW, PartType.FEETPAD],
	PartType.PAW: [PartType.CLAW],
	PartType.TENTACLE: [PartType.SUCKER, PartType.CLAW, PartType.ABMUSCLES],
	PartType.NOSE: [PartType.JACOBSON],
	PartType.EAR: [PartType.TYMPANUM],
	PartType.COATING: [PartType.SKIN, PartType.PELT, PartType.SCALES],
	PartType.MOUTH: [PartType.TONGUE],
	PartType.TAIL: [PartType.HORN, PartType.FIN, PartType.FLIPPER]
}

func valid_connection(parent: PartType, child: PartType) -> bool:
	return valid_connections.has(parent) and child in valid_connections[parent]

func get_valid_connections():
	return valid_connections

func count_limb_sequences(connection_data: Dictionary) -> Dictionary:
	var sequences = {
		"leg": person_leg_sequence,
		"arm": person_arm_sequence
	}
	var counts := {}

	for label in sequences.keys():
		var sequence = sequences[label]
		counts[label] = {}

		for parent in connection_data.keys():
			for child in connection_data[parent]:
				if _match_sequence_recursive(connection_data, child, sequence.duplicate(), 0):
					var size = sequence.size()
					counts[label][size] = counts[label].get(size, 0) + 1

	return counts

func _match_sequence_recursive(connection_data: Dictionary, current: String, sequence: Array, index: int) -> bool:
	if index >= sequence.size():
		return true
	var expected_type = sequence[index]
	if not current.ends_with(str(expected_type)):
		return false
	if index == sequence.size() - 1:
		return true
	if not connection_data.has(current):
		return false
	for child in connection_data[current]:
		if _match_sequence_recursive(connection_data, child, sequence, index + 1):
			return true
	return false
