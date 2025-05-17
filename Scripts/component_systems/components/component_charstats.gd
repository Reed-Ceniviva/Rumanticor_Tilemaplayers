extends Resource
class_name component_charstats

var age : float = 0.0
var sex : bool = true
var char_name : String = "John"
#var strength : float = 10.0

func setup(_char_name : String = "John", _sex : bool = true, _age : float = 0.0):
	age = _age
	sex = _sex
	char_name = _char_name
