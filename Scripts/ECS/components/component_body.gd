# component_body.gd
extends Component
class_name ComponentBody

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
HAIR
} 

enum BodyActions {WALK, RUN, JUMP, LOOK, SENSE, HEAR, CLIMB, SWING, AIM, KICK, TASTE, GRAB, SMELL, FEEL, CRAWL, ROLL, SPRINT, LIMP, DRAG, HANDRUN, SLITHER, THROW}

enum PartSide {LEFT, CENTER, RIGHT, ALL}
enum PartLevel {LOWER, MIDDLE, UPPER, HEAD, ALL}
#enum PartFace {FRONT, BACK, ALL, NA}

var mobilePartTypes = [PartType.LEG, PartType.KNEE, PartType.HIP, PartType.FOOT, PartType.HOOF, PartType.PAW, PartType.TENTACLE, PartType.ABMUSCLES, PartType.FEETPAD, PartType.WING, PartType.FIN, PartType.ARM, PartType.SHOULDER, PartType.HAND, PartType.ELBOW]
var jointPartTypes = [PartType.KNEE, PartType.ELBOW, PartType.NECK, PartType.SHOULDER, PartType.HIP, PartType.HAND, PartType.PAW, PartType.ABMUSCLES]
var limbPartTypes = [PartType.HEAD, PartType.ARM, PartType.LEG, PartType.COD, PartType.TENTACLE]
var extremityPartTypes = [PartType.HAIR, PartType.HEAD, PartType.HAND, PartType.HOOF, PartType.PAW, PartType.FEETPAD, PartType.TAIL, PartType.FOOT, PartType.FIN, PartType.WING]
var sensoryPartTypes = [PartType.EYE, PartType.EAR, PartType.NOSE, PartType.SKIN, PartType.PIT, PartType.TENTACLE, PartType.WHISKER, PartType.ANTENNA, PartType.JACOBSON, PartType.LATERALLINE, PartType.ELECTRORECEPTOR, PartType.TYMPANUM, PartType.LABIALPALP]
var visionPartTypes = [PartType.EYE, PartType.PIT]
var touchPartTypes = [PartType.SKIN, PartType.WHISKER, PartType.ANTENNA, PartType.LABIALPALP]
var smellPartTypes = [PartType.NOSE, PartType.JACOBSON, PartType.ANTENNA]
var tastePartTypes = [PartType.TONGUE,PartType.LABIALPALP]
var fieldPartTypes = [PartType.ELECTRORECEPTOR, PartType.TYMPANUM, PartType.LATERALLINE, PartType.HAIR]
#average human walking speed : 1.34 m/s given: bipedal: 2 hips with 1 leg each with 1 knee each with 1 foot each

var part_id = 0
var next_part_id = 1
var parts: Dictionary [int,ComponentBodyPart]
var part_groups: Dictionary [ComponentBody.PartType,Array]

func _init():
	comp_name = "body"

func add_part(part: ComponentBodyPart, root_body : ComponentBody):
	var new_part_id = root_body.next_part_id
	part.part_id = new_part_id
	part.parent_part = self
	parts[new_part_id] = part
	part_groups[part.type].append(new_part_id)
	root_body.next_part_id += 1

func add_to_part(part : ComponentBodyPart, target_part : ComponentBodyPart, root_body : ComponentBody):
	get_part(target_part.part_id).add_part(part,root_body)

func get_part_flat(_part_id: int) -> ComponentBodyPart:
	return parts.get(_part_id, null)

func has_part_flat(_part_id: int) -> bool:
	return parts.has(_part_id)

func remove_part(_part_id : int) -> bool:
	if has_part(_part_id):
		if part_groups[parts[_part_id].type].has(_part_id):
			part_groups[parts[_part_id].type].erase(_part_id)
			return parts.erase(_part_id)
		else:
			print("part not found in part groups")
			return false
	else:
		print("part id not found in list of parts")
		return false

func get_all_parts() -> Dictionary[int,ComponentBodyPart]:
	var all_parts = parts.duplicate()
	for part in parts.values():
		if part is ComponentBody:
			var subparts = part.get_all_parts()
			for id in subparts:
				all_parts[id] = subparts[id]
	return all_parts

func get_total_parts() -> int:
	return get_all_parts().size()

func get_part_group(_part_type : ComponentBody.PartType) -> Array[ComponentBodyPart]:
	if part_groups.has(_part_type):
		return part_groups[_part_type]
	else:
		return []

func get_part(_part_id: int) -> ComponentBodyPart:
	if parts.has(_part_id):
		return parts[_part_id]

	for part in parts.values():
		if part is ComponentBody:
			var found = part.get_part(_part_id)
			if found:
				return found
	return null

func has_part(_part_id: int) -> bool:
	if parts.has(_part_id):
		return true
	for part in parts.values():
		if part is ComponentBody and part.has_part(_part_id):
			return true
	return false

var leg_sequence = [PartType.HIP, PartType.LEG, PartType.KNEE, PartType.LEG, PartType.FOOT]
var arm_sequence = [PartType.SHOULDER, PartType.ARM, PartType.ELBOW, PartType.ARM, PartType.HAND]

#might need to include an array of nodes to ignore so that this is useful for anything more than a head ( having two of a sequence would mean you may never get the other as a return
func has_part_sequence(part_sequence: Array, is_terminating: bool = false) -> bool:
	if part_sequence.is_empty():
		return true
		
	var current_type = part_sequence[0]
	
	for part_id in parts:
		var part = parts[part_id]
		if part.type == current_type:
			# Duplicate array to avoid mutating the original
			var sub_sequence = part_sequence.duplicate()
			sub_sequence.remove_at(0)
			
			# If this is the end of the sequence, check termination if needed
			if sub_sequence.is_empty():
				if is_terminating and part is ComponentBody and part.parts.size() != 0:
					return false
				return true
			# Recurse if this part has children
			if part is ComponentBody:
				if part.has_part_sequence(sub_sequence, is_terminating):
					return true
					
	# If none matched
	return false

func part_sequence_count(part_sequence: Array, is_terminating: bool = false) -> int:
	if part_sequence.is_empty():
		return 0

	var current_type = part_sequence[0]
	var best_match = 0

	for part_id in parts:
		var part = parts[part_id]
		if part.type == current_type:
			var sub_sequence = part_sequence.duplicate()
			sub_sequence.remove_at(0)

			if sub_sequence.is_empty():
				if is_terminating and part is ComponentBody and part.parts.size() != 0:
					continue  # terminate match here if tail has more children
				return part_sequence.size()  # full match

			# Recurse into child parts
			if part is ComponentBody:
				var sub_match = part.part_sequence_count(sub_sequence, is_terminating)
				if sub_match > 0:
					var total_match = 1 + sub_match
					if total_match > best_match:
						best_match = total_match

	# If nothing fully matched, return best partial match (0 if none)
	return best_match

func get_matching_sequence_starts(part_sequence: Array, is_terminating: bool = false) -> Array:
	var matching_starts: Array = []

	for part_id in parts:
		var part = parts[part_id]
		if part.type == part_sequence[0]:
			var sub_sequence = part_sequence.duplicate()
			if _match_sequence_recursive(part, sub_sequence, is_terminating):
				matching_starts.append(part_id)

	return matching_starts

func _match_sequence_recursive(current_part: ComponentBodyPart, sequence: Array, is_terminating: bool) -> bool:
	if sequence.is_empty():
		return true

	if current_part.type != sequence[0]:
		return false

	sequence.remove_at(0)

	if sequence.is_empty():
		if is_terminating and current_part is ComponentBody and current_part.parts.size() != 0:
			return false
		return true

	if current_part is ComponentBody:
		for sub_part_id in current_part.parts:
			var sub_part = current_part.parts[sub_part_id]
			var sub_seq = sequence.duplicate()
			if _match_sequence_recursive(sub_part, sub_seq, is_terminating):
				return true

	return false
