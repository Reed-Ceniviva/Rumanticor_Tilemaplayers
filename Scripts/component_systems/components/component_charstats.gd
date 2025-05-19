extends Resource
class_name component_charstats

var FIRST_NAMES = ["Reed", "Trevor", "George", "Lindsey", "Nick", "David", "Alexander", "Rolland", 
"Marie", "Joseph", "Gail", "Audry", "Ryan", "Cory", "Zach", "William", "James", "Jack", "Jacob",
"Bonnie", "Moo", "Dianne", "Bill", "Mario", "JD", "Jason", "Frank", "Rachel", "Cindy", "Peggy", 
"Charlene", "Charmaine", "Dave", "Davey", "Owen", "Steven", "Jamie", "Cody", "Brody", "Emma", 
"Julia", "Brendan", "Lueis", "Warner", "Hazel", "Bryce", "Mason", "Lauren", "Michele"]

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
