extends Node
class_name ActionRegistry

static var registered_actions: Array[GOAPAction] = []
static var initialized := false

static func initialize():
	if initialized:
		return
	initialized = true
	registered_actions.append(FindTreeInSightAction.new())
	#registered_actions.append(ChopTreeAction.new())
	registered_actions.append(FindSaughtEntityInSight.new())
	#registered_actions.append(EquipTargetItemAction.new())
	registered_actions.append(MoveToTargetAction.new())
	registered_actions.append(AttackTargetWithEquippedAction.new())
	registered_actions.append(FindAxeInSightAction.new())

static func get_applicable_actions(entity: Entity) -> Array[GOAPAction]:
	if not initialized:
		initialize()

	var result: Array[GOAPAction] = []
	for action in registered_actions:
		if action.is_applicable(entity):
			#print("Applicable action: ", action.name)
			result.append(action.duplicate())
		else:
			pass
			#print("Inapplicable action: ", action.name)
	return result
