extends Component
class_name ComponentHealth

@export var current_health: int = 100
@export var max_health: int = 100

func _init():
	comp_name = "health"

func is_alive() -> bool:
	return current_health > 0

func apply_damage(amount: int) -> void:
	current_health = max(0, current_health - amount)

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)
