# entity_body.gd
extends Entity
class_name EntityBody

const BodyData = preload("uid://rhetoeckohcj")

@export var root_part: EntityBodyPart
@export var coating : BodyData.PartType
@export var connection_data: Dictionary[int,Array]
var _BodyData

func _ready():
	_BodyData = BodyData.new()
	# Optional: validate body structure at runtime
	_validate_connections()

func _validate_connections():
	_validate_recursive(root_part)

func _validate_recursive(part: EntityBodyPart):
	if part.parent:
		if not _BodyData.valid_connection(part.parent.part_type, part.part_type):
			push_error("Invalid connection from %s to %s" % [str(part.parent.part_type), str(part.part_type)])
	for child in part.children:
		_validate_recursive(child)

func get_all_parts() -> Array[EntityBodyPart]:
	var parts: Array[EntityBodyPart] = []
	_collect_parts_recursive(root_part, parts)
	return parts

func _collect_parts_recursive(part: EntityBodyPart, parts: Array):
	parts.append(part)
	for child in part.children:
		_collect_parts_recursive(child, parts)

func update_connection_data():
	connection_data.clear()
	_fill_connection_data_recursive(root_part)

func _fill_connection_data_recursive(part: EntityBodyPart):
	if part.children.size() > 0:
		var child_ids := []
		for child in part.children:
			child_ids.append(child.entity_id)
		connection_data[part.entity_id] = child_ids
	for child in part.children:
		_fill_connection_data_recursive(child)
