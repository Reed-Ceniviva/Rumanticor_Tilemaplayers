extends ComponentBodyPart
class_name ComponentBrain

const ComponentSense = preload("uid://cjsv7ucry3tgg")

var PartsDict = {}
var senses = {}

var my_body : ComponentBody
#var my_mobility : ComponentMobile

var mobile_body_parts : Array
var vision_body_parts

func _init(_body : ComponentBody):
	comp_name = "brain"
	my_body = _body
	var my_body_parts = my_body.get_all_parts()
	for bodypart in my_body_parts.values():
		if my_body.mobilePartTypes.has(bodypart.type):
			mobile_body_parts[bodypart.type].append(bodypart.part_id)
		elif my_body.visionPartTypes.has(bodypart.type):
			vision_body_parts[bodypart.type].append(bodypart.part_id)
			senses[ComponentSense.SenseType.VISION].append(ComponentVision.new(bodypart))
			
	if not mobile_body_parts.is_empty():
		pass
		#my_mobility = ComponentMobile.new(mobile_body_parts)
			#the brain makes note of what mobile parts it has and how it is able to move with them
