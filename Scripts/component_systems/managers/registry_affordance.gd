extends Node
class_name AffordanceRegistry

# Maps component types to goal creation lambdas
static var affordances: Dictionary = {}

func _ready():
	affordances["EquipmentComponent"] = func(entity):
		var goals : Array[Goal] = []
		var goal = TargetItemEquippedGoal.new()
		#unsure if the location of the target is known to the entity, 
		goal.priority = EntityRegistry._entity_store[entity.get_component_by_type("TargetEntityComponent")].get_component_by_type("PositionComponent").pos.distance_to(entity.get_component_by_type("PositionComponent").pos)
		goals.append(goal)
		
		var goal2 = BecomeHousedGoal.new()
		goal2.priority = 2.0
		goals.append(goal2)
		
		return goals
	
	
	affordances["SaughtEntityComponent"] = func(entity : Entity):
		if entity.has_component_type("VisionComponent"):
			return [LocateSaughtGoal.new()]
	
	affordances["MovementPathComponent"] = func(entity : Entity):
		if entity.has_component_type("MobilityComponent"):
			return [MoveToTargetAction.new()]

	affordances["TargetEntityComponent"] = func(entity : Entity):
		return [KillTargetGoal.new()]
