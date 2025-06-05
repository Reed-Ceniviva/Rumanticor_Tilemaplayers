extends Component
class_name ComponentGrowth

# in meters per year
var width_growth : float = 0.0
var standing_growth_childhood : float = 0.05 #meters per year
var standing_growth_puberty : float = 0.08


func _init():
	comp_name = "growth"
	
