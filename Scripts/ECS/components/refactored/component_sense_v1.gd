extends Component
class_name ComponentSense

enum SenseType {
	VISION, #sight in distance
	SMELL, #scent detection ~ parts per 1000 or something similar maybe
	HEARING, #hearing sensitivity ~
	TOUCH, #touch/pressure sensitivity ~
	TASTE, #ability to discerne different tastes ~
	FIELD #field sensitivity~
	}

var type : SenseType
var associated_bodypart : ComponentBodyPart

func _init(sensing_type : SenseType, sensing_body_part : ComponentBodyPart):
	comp_name = "sense"
	type = sensing_type
	associated_bodypart = sensing_body_part
	
