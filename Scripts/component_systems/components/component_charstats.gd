extends Resource
class_name component_charstats

var age : float = 0.0
var sex : bool = true
var char_name : String = "John"
var action_delay: float = 0.25
var next_action_time: float = 0.0
#var strength : float = 10.0

func setup(_char_name : String = "John", _sex : bool = true, _age : float = 0.0, _action_delay : float = 0.25, _next_action_time : float = 0.0):
	age = _age
	sex = _sex
	char_name = _char_name
	action_delay = _action_delay
	next_action_time = _next_action_time
