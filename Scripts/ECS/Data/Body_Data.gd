extends Resource
class_name BodyData

enum PartType { HEAD, 
NECK, #parent head, child spine
SPINE, # joint parent neck, child torso
SHOULDER, #joint, parent neck, child arm
ARM, #,limb,climbing,primates,true
ELBOW,# joint, parent arm, child arm
HAND, #parent arm
TORSO, # parent spine, all children
COD, # parent torso, brother leg, no child
HIP, # joint, parent torso, child leg
LEG, #,limb,walking,mammals,true
KNEE, #joint, parent leg, child leg
FOOT, #extremity,walking,birds,true
TAIL, #appendage,balance/swimming,monkeys,false
EYE, #,organ,vision,mammals true
NOSE, #organ,smell,mammals false
EAR, #,organ,hearing,mammals true
TONGUE, #organ,taste/reception,amphibians false
WING, #,limb,flying,birds,true
FIN, #appendage,swimming,fish,true
HOOF, #,extremity,walking,ungulates,true
PAW, #extremity,walking,dogs true
CLAW, #,extremity,gripping/burrowing,birds/reptiles,true
TENTACLE, #,limb,gripping/moving,octopuses,true
ABMUSCLES, #muscle,slithering/snaking,snakes,false
FEETPAD, #extremity,gripping/climbing,frogs true
SKIN, #organ,touch/temperature,mammals false since this would be a child of all external  | this would be applied to all external parts so maybe change how this is applied/ external coatings
WHISKER, #(Vibrissae),hair,touch/navigation,cats/seals true
ANTENNA, #touch/smell/hearing,insects/crustaceans true
JACOBSON, #(Vomeronasal Organ),organ,pheromone detection,snakes/cats false
LATERALLINE, #organ,water movement detection,fish/amphibians false
ELECTRORECEPTOR, #cell cluster,electric field detection,sharks/platypus false
PIT, #organ,infrared sensing,pit vipers false
TYMPANUM, #membrane,sound detection,amphibians/insects true
LABIALPALP, #appendage,taste/touch,mollusks/insects true
BRAIN,
HAIR,
SUCKER,
GENITALS,
MOUTH
} 

enum BodyActions {
WALK, RUN, JUMP,  CLIMB,  CRAWL, ROLL, SPRINT, LIMP, DRAG, HANDRUN, SLITHER,
LOOK, SENSE, HEAR, TASTE, SMELL, FEEL, 
SWING, AIM, KICK, GRAB, THROW, LOB 
}

enum PartSide {LEFT, CENTER, RIGHT, ALL}
enum PartLevel {LOWER, MIDDLE, UPPER, HEAD, ALL}

var mobilePartTypes = [PartType.LEG, PartType.KNEE, PartType.HIP, PartType.FOOT, PartType.HOOF, PartType.PAW, PartType.TENTACLE, PartType.ABMUSCLES, PartType.FEETPAD, PartType.WING, PartType.FIN, PartType.ARM, PartType.SHOULDER, PartType.HAND, PartType.ELBOW]
var jointPartTypes = [PartType.KNEE, PartType.ELBOW, PartType.NECK, PartType.SHOULDER, PartType.HIP, PartType.HAND, PartType.PAW, PartType.ABMUSCLES]
var limbPartTypes = [PartType.HEAD, PartType.ARM, PartType.LEG, PartType.COD, PartType.TENTACLE]
var extremityPartTypes = [PartType.GENITALS, PartType.SUCKER, PartType.HAIR, PartType.HEAD, PartType.HAND, PartType.HOOF, PartType.PAW, PartType.FEETPAD, PartType.TAIL, PartType.FOOT, PartType.FIN, PartType.WING]
var organPartTypes = [PartType.MOUTH, PartType.GENITALS, PartType.BRAIN, PartType.PIT, PartType.LATERALLINE,  PartType.ABMUSCLES, PartType.TONGUE, PartType.EAR, PartType.NOSE, PartType.EYE]
var sensoryPartTypes = [PartType.EYE, PartType.EAR, PartType.NOSE, PartType.PIT, PartType.TENTACLE, PartType.WHISKER, PartType.ANTENNA, PartType.JACOBSON, PartType.LATERALLINE, PartType.ELECTRORECEPTOR, PartType.TYMPANUM, PartType.LABIALPALP]
var visionPartTypes = [PartType.EYE, PartType.PIT]
var touchPartTypes = [PartType.SKIN, PartType.WHISKER, PartType.ANTENNA, PartType.LABIALPALP, PartType.SUCKER]
var smellPartTypes = [PartType.NOSE, PartType.JACOBSON, PartType.ANTENNA]
var tastePartTypes = [PartType.TONGUE,PartType.LABIALPALP]
var fieldPartTypes = [PartType.ELECTRORECEPTOR, PartType.TYMPANUM, PartType.LATERALLINE, PartType.HAIR]
var bonePartTypes = [PartType.SPINE]

var full_leg_sequence = [PartType.HIP, PartType.LEG, PartType.KNEE, PartType.LEG, PartType.FOOT]
var full_arm_sequence = [PartType.SHOULDER, PartType.ARM, PartType.ELBOW, PartType.ARM, PartType.HAND]

var valid_connections := {
	PartType.HEAD: [
		PartType.EYE, PartType.NOSE, PartType.EAR, PartType.MOUTH,
		PartType.WHISKER, PartType.ANTENNA, PartType.JACOBSON, PartType.TYMPANUM,
		PartType.LABIALPALP, PartType.HAIR, PartType.BRAIN,
		PartType.PIT, PartType.LATERALLINE, PartType.ELECTRORECEPTOR,
		PartType.NECK
	],
	PartType.NECK: [PartType.SPINE],
	PartType.SPINE: [PartType.TORSO],
	PartType.TORSO: [PartType.HIP, PartType.SHOULDER, PartType.COD, PartType.TAIL, PartType.SKIN, PartType.ABMUSCLES, PartType.WING, PartType.FIN, PartType.SPINE],
	PartType.SHOULDER: [PartType.ARM],
	PartType.COD: [PartType.GENITALS],
	PartType.HIP: [PartType.LEG],
	PartType.LEG: [PartType.KNEE, PartType.FOOT, PartType.LEG, PartType.HOOF, PartType.PAW],
	PartType.KNEE: [PartType.LEG],
	PartType.FOOT: [PartType.FEETPAD],
	PartType.HOOF: [],
	PartType.ABMUSCLES: [],
	PartType.ARM: [PartType.ELBOW, PartType.HAND, PartType.ARM],
	PartType.ELBOW: [PartType.ARM],
	PartType.HAND: [PartType.CLAW, PartType.FEETPAD],
	PartType.PAW: [PartType.CLAW],
	PartType.TENTACLE: [PartType.SUCKER, PartType.CLAW, PartType.ABMUSCLES],
	PartType.NOSE: [PartType.JACOBSON],
	PartType.EAR: [PartType.TYMPANUM],
	PartType.SKIN: [PartType.HAIR],
	PartType.MOUTH: [PartType.TONGUE],
}

func valid_connection(parent: PartType, child: PartType) -> bool:
	return valid_connections.has(parent) and child in valid_connections[parent]

func get_valid_connections():
	return valid_connections
