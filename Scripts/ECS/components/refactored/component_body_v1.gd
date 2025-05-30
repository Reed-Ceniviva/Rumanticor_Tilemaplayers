# component_body.gd
extends Entity
class_name ComponentBody_v1

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
SKIN, #organ,touch/temperature,mammals false
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
#enum PartFace {FRONT, BACK, ALL, NA}

var mobilePartTypes = [PartType.LEG, PartType.KNEE, PartType.HIP, PartType.FOOT, PartType.HOOF, PartType.PAW, PartType.TENTACLE, PartType.ABMUSCLES, PartType.FEETPAD, PartType.WING, PartType.FIN, PartType.ARM, PartType.SHOULDER, PartType.HAND, PartType.ELBOW]
var jointPartTypes = [PartType.KNEE, PartType.ELBOW, PartType.NECK, PartType.SHOULDER, PartType.HIP, PartType.HAND, PartType.PAW, PartType.ABMUSCLES]
var limbPartTypes = [PartType.HEAD, PartType.ARM, PartType.LEG, PartType.COD, PartType.TENTACLE]
var extremityPartTypes = [PartType.GENITALS, PartType.SUCKER, PartType.HAIR, PartType.HEAD, PartType.HAND, PartType.HOOF, PartType.PAW, PartType.FEETPAD, PartType.TAIL, PartType.FOOT, PartType.FIN, PartType.WING]
var organPartTypes = [PartType.MOUTH, PartType.GENITALS, PartType.BRAIN, PartType.PIT, PartType.LATERALLINE, PartType.SKIN, PartType.ABMUSCLES, PartType.TONGUE, PartType.EAR, PartType.NOSE, PartType.EYE]
var sensoryPartTypes = [PartType.EYE, PartType.EAR, PartType.NOSE, PartType.SKIN, PartType.PIT, PartType.TENTACLE, PartType.WHISKER, PartType.ANTENNA, PartType.JACOBSON, PartType.LATERALLINE, PartType.ELECTRORECEPTOR, PartType.TYMPANUM, PartType.LABIALPALP]
var visionPartTypes = [PartType.EYE, PartType.PIT]
var touchPartTypes = [PartType.SKIN, PartType.WHISKER, PartType.ANTENNA, PartType.LABIALPALP, PartType.SUCKER]
var smellPartTypes = [PartType.NOSE, PartType.JACOBSON, PartType.ANTENNA]
var tastePartTypes = [PartType.TONGUE,PartType.LABIALPALP]
var fieldPartTypes = [PartType.ELECTRORECEPTOR, PartType.TYMPANUM, PartType.LATERALLINE, PartType.HAIR]
#average human walking speed : 1.34 m/s given: bipedal: 2 hips with 1 leg each with 1 knee each with 1 foot each

var full_leg_sequence = [PartType.HIP, PartType.LEG, PartType.KNEE, PartType.LEG, PartType.FOOT]
var full_arm_sequence = [PartType.SHOULDER, PartType.ARM, PartType.ELBOW, PartType.ARM, PartType.HAND]

# Define parent-to-child structural constraints
var valid_connections := {
	# Core body structure
	PartType.SPINE: [PartType.TORSO, PartType.NECK],
	PartType.NECK: [PartType.HEAD],
	PartType.TORSO: [PartType.HIP, PartType.SHOULDER, PartType.COD, PartType.TAIL, PartType.SKIN, PartType.ABMUSCLES, PartType.WING, PartType.FIN],
	PartType.COD: [PartType.GENITALS], # fish-like tails or tentacle base

	# Legs and walking appendages
	PartType.HIP: [PartType.LEG],
	PartType.LEG: [PartType.KNEE, PartType.FOOT, PartType.LEG, PartType.HOOF, PartType.PAW],  # double segments
	PartType.KNEE: [PartType.LEG],  # upper to lower
	PartType.FOOT: [PartType.FEETPAD],
	PartType.HOOF: [],
	PartType.ABMUSCLES: [],

	# Arms and manipulation
	PartType.SHOULDER: [PartType.ARM],
	PartType.ARM: [PartType.ELBOW, PartType.HAND, PartType.ARM],  # e.g. forearm/upperarm
	PartType.ELBOW: [PartType.ARM],
	PartType.HAND: [PartType.CLAW, PartType.FEETPAD],
	PartType.PAW: [PartType.CLAW],

	PartType.TENTACLE: [PartType.SUCKER, PartType.CLAW, PartType.ABMUSCLES],  # if implemented

	# Head & sensory
	PartType.HEAD: [
		PartType.EYE, PartType.NOSE, PartType.EAR, PartType.MOUTH,
		PartType.WHISKER, PartType.ANTENNA, PartType.JACOBSON, PartType.TYMPANUM,
		PartType.LABIALPALP, PartType.HAIR, PartType.BRAIN, PartType.SKIN,
		PartType.PIT, PartType.LATERALLINE, PartType.ELECTRORECEPTOR
	],

	# Sensory sub-structures (many are extremities or nested)
	PartType.NOSE: [PartType.JACOBSON],
	PartType.EAR: [PartType.TYMPANUM],
	PartType.SKIN: [PartType.HAIR],
	PartType.MOUTH: [PartType.TONGUE],

}



var part_id = 0
var next_part_id = 1
var child_parts : Array[int] = []
var all_parts: Dictionary[int, ComponentBodyPart] = {}

func add_part(part: ComponentBodyPart, root: ComponentBody, parent_id : int = -1) -> void:
	# Assign a unique ID
	part.part_id = root.next_part_id
	root.next_part_id += 1

	# Set parent-child relationships
	part.parent_id = self.part_id
	if parent_id != -1 and root.all_parts.has(parent_id):
		root.all_parts[parent_id].child_parts.append(part.part_id)
		root.all_parts[parent_id].all_parts[part.part_id] = part
	else:
		self.child_parts.append(part.part_id)
		self.all_parts[part.part_id] = part
	root.child_parts.append(part.part_id)
	root.all_parts[part.part_id] = part


func add_part_to(part: ComponentBodyPart, target_part_id : int, root_body: ComponentBody):
	add_part(part, root_body, target_part_id)



func get_part_flat(_part_id: int) -> ComponentBodyPart:
	return all_parts.get(_part_id, null)

func has_part_flat(_part_id: int) -> bool:
	return all_parts.has(_part_id)

func remove_part(part_id: int) -> void:
	var part = get_part(part_id)
	if part:
		if part.parent_id != -1:
			var parent = get_part(part.parent_id)
			parent.child_parts.erase(part_id)
			parent.all_parts.erase(part_id)
		all_parts.erase(part_id)

func get_all_parts() -> Dictionary[int, ComponentBodyPart]:
	return all_parts


func get_total_parts() -> int:
	return all_parts.size()

func get_part(part_id: int) -> ComponentBodyPart:
	return all_parts.get(part_id, null)


func has_part(_part_id: int) -> bool:
	return all_parts.has(_part_id)

#might need to include an array of nodes to ignore so that this is useful for anything more than a head ( having two of a sequence would mean you may never get the other as a return
func has_part_sequence(start_id: int, part_sequence: Array, is_terminating := false) -> bool:
	if part_sequence.is_empty(): return true
	var current_part = get_part(start_id)
	if current_part.type != part_sequence[0]: return false
	if part_sequence.size() == 1:
		if is_terminating and current_part.children.size() > 0:
			return false
		return true
	var next_sequence = part_sequence.slice(1, part_sequence.size() - 1)
	for child_id in current_part.child_parts:
		if has_part_sequence(child_id, next_sequence, is_terminating):
			return true
	return false
