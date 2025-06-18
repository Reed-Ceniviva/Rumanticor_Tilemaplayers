extends Node
class_name AffordanceRegistry

# Maps component types to goal creation lambdas
static var affordances: Dictionary = {}

func _ready():
	affordances["EquipmentComponent"] = func(entity):
		var goal = TargetItemEquippedGoal.new()
		#unsure if the location of the target is known to the entity, 
		goal.priority = EntityRegistry._entity_store[entity.get_component_by_type("TargetEntityComponent")].get_component_by_type("PositionComponent").pos.distance_to(entity.get_component_by_type("PositionComponent").pos)
		var goal2 = BecomeHousedGoal.new()
		goal2.priority = 2.0
		
		return [goal, goal2]
	affordances["MovementPathComponent"] = func(entity):
		pass
		#return [TalkToEntityGoal.new()]
	# Extend with other mappings...
