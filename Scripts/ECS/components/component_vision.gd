extends ComponentSense
class_name ComponentVision

enum BlindnessTypes {FULL, MONO, DICHRG, DICHGB, DICHRB, POMALY, DOMALY, TOMALY}

var sight_max = 1 #number of tiles an entity can see away from themselves
var sight_min = 0 #maybe something could be farsighted idk
var inf_vision : bool = false

func _init(parent_body_part : ComponentBodyPart, init_sigh_max : int = 1, init_sight_min : int = 0):
	comp_name = "vision"
	associated_bodypart = parent_body_part
	type = SenseType.VISION
	sight_max = init_sigh_max
	sight_min = init_sight_min
	if associated_bodypart.type == associated_bodypart.PartType.PIT:
		inf_vision = true
