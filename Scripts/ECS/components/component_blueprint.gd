extends Component
class_name ComponentBlueprint

# speed = meter / second

var min_walk_speed = 0.8
var avg_walk_speed = 1.78
var max_walk_speed = 3.3

var max_hand_walk_speed = 4.0

var max_no_knee_walk_speed = 7.0

var min_crawl_speed = 0.1
var avg_crawl_speed = 0.5
var max_crawl_speed = 1.47

var max_sight_distance = 32
var min_sight_distance = 0
var inf_vision = false

#number of locomotive limbs
var pedal = 2

# locomotive body parts or limbs
var leg_count = 2
var wing_count = 0
var wheel_count = 0
var tread_count = 0
var fin_count = 0
var tentical_count = 0

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
	
