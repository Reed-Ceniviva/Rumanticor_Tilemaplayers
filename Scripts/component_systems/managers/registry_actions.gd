extends Node
class_name ActionRegistry

var registered_actions: Array[GOAPAction] = []

func _ready():
	# Register global actions here
	registered_actions.append(FindTreeInSightAction.new())
	#registered_actions.append(ChopTreeAction.new())
	registered_actions.append(MoveToTargetAction.new())
	# Add more as needed

func get_applicable_actions(entity: Entity) -> void:
	var result := []
	for action in registered_actions:
		if action.is_applicable(entity):
			result.append(action.duplicate())  # So it's not shared across entities
	entity.get_component_by_type("AvailableActionsComponent").actions = result
