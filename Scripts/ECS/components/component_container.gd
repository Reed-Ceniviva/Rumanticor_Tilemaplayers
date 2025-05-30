extends Component
class_name ComponentContainer


var max_volume: float # max volume the container can hold
var contents: Dictionary[int , float]  # IDs or references to item entities
var mode: String = "random"  # Determines how to calculate volume use
var current_volume: float # amount of volume currently being held

func _init():
	comp_name = "container"
