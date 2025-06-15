# health_component.gd
extends Component
class_name HealthComponent

@export var max_health: int = 100
@export var current_health: int = 100

func _init(init_max_health : int = max_health, init_current_health : int = init_max_health):
	max_health = init_current_health
	current_health = init_current_health
	component_name = "HealthComponent"
	super._init()

func is_alive() -> bool:
	return current_health > 0

func take_damage(amount: int) -> void:
	current_health = max(current_health - amount, 0)

func heal(amount: int) -> void:
	current_health = min(current_health + amount, max_health)
