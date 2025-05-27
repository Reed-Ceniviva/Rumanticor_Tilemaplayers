class_name EntityBody
extends EntityBase

var root_parts: Array[ComponentBodyPart] = []
const BodyData = preload("uid://rhetoeckohcj")

func add_body_part(part: ComponentBodyPart, parent: ComponentBodyPart = null) -> void:
	if parent:
		parent.add_child_part(part)
	else:
		root_parts.append(part)

	add_component(part)  # Also treat BodyPart as a component for ECS access

func get_all_parts() -> Array[ComponentBodyPart]:
	var parts: Array[ComponentBodyPart] = []
	for root in root_parts:
		parts.append_array(root.get_all_descendants())
	return parts

func has_full_limb_sequence(sequence: Array[BodyData.PartType]) -> bool:
	for part in get_all_parts():
		if part.match_sequence(sequence):
			return true
	return false
