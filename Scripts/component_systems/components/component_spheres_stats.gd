extends Component
class_name SphereStatsComponent

var stats : Dictionary = {
	"Strength": 1.0,
	"Nature":1.0,
	"Art":1.0,
	"Social":1.0,
	"Inspiration":1.0,
	"Fear":1.0,
	"Luck":1.0,
	"Wisdom":1.0
}

func _init():
	component_name = "SphereStatsComponent"
	super._init()
