extends Component
class_name MobilityComponent

var traversable : Dictionary[String,float]

#this does not include things like cliffs or mountains as those are extensions of ground mobility 
#{
#"ground" : 1.0
#"air" : 0.0 #this would mean you can hover
#"water" : 0.0 #if a medium of mobility is not present the entity cannot traverse it
#}

func _init():
	component_name = "MobilityComponent"
	super._init()

func _ready(init_traversability : Dictionary = {}):
	if init_traversability.is_empty():
		traversable = {
			"ground" : 1.0
		}
	else:
		traversable = init_traversability
	
