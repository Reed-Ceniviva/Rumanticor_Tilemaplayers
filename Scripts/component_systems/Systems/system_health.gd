extends System
class_name HealthSystem

func _init():
	required_components = ["HealthComponent"]

func process(entity: Entity) -> void:
	var health : HealthComponent = entity.get_component_by_type("HealthComponent")
	if health:
		if !health.is_alive():
			entity.die()
	
