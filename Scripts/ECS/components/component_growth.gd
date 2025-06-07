extends Component
class_name ComponentGrowth

# in meters per year
var width_growth : float = 0.0
var standing_growth_childhood : float = 0.00 # 0.05 #meters per year
var standing_growth_puberty : float = 0.00 #0.08
var standing_growth : float = 0.01
var part_growth = {} # {arm = 1}


func _init():
	comp_name = "growth"
	
