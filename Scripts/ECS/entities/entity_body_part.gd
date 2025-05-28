# component_body_part.gd
class_name EntityBodyPart
extends EntityBase  # Now inherits body logic

const BodyData = preload("uid://rhetoeckohcj")
var my_BodyData = BodyData.new()

var part_type: BodyData.PartType
var side: BodyData.PartSide = BodyData.PartSide.CENTER
var level: BodyData.PartLevel = BodyData.PartLevel.MIDDLE
var parent_part: EntityBodyPart = null
var child_parts: Array[EntityBodyPart] = []


func get_comp_name() -> String:
	return "BodyPart_%s" % str(part_type)

func add_child_part(part: EntityBodyPart):
	if part == self or part in get_all_descendants():
		push_warning("Cannot add part as a descendant of itself")
		return

	var parent_allows = part.part_type in my_BodyData.get_valid_connections().get(part_type, [])
	var child_allows = part_type in my_BodyData.get_valid_connections().get(part.part_type, [])

	if parent_allows and child_allows:
		child_parts.append(part)
		part.parent_part = self
	else:
		push_warning("Invalid bidirectional connection: %s ↔ %s" % [part_type, part.part_type])

func get_all_descendants() -> Array[EntityBodyPart]:
	var all = [self]
	for child in child_parts:
		all.append_array(child.get_all_descendants())
	return all

func match_sequences(sequence: Array[BodyData.PartType]) -> Array[Dictionary]:
	var matches: Array[Dictionary] = []
	_match_sequence_recursive(sequence, 0, [], [], matches)
	return matches

func _match_sequence_recursive(
	sequence: Array[BodyData.PartType],
	index: int,
	path: Array,
	mismatches: Array,
	matches: Array
) -> void:
	var new_path = path.duplicate()
	var new_mismatches = mismatches.duplicate()

	if index < sequence.size():
		if part_type == sequence[index]:
			new_path.append(part_type)
			if index == sequence.size() - 1:
				matches.append({
					"matched": true,
					"match_path": new_path,
					"mismatches": new_mismatches,
					"score": float(new_path.size()) / float(sequence.size())
				})
				return
			for child in child_parts:
				child._match_sequence_recursive(sequence, index + 1, new_path, new_mismatches, matches)
		else:
			new_mismatches.append(part_type)
			for child in child_parts:
				child._match_sequence_recursive(sequence, index, new_path, new_mismatches, matches)
	else:
		matches.append({
			"matched": true,
			"match_path": new_path,
			"mismatches": new_mismatches,
			"score": float(new_path.size()) / float(sequence.size())
		})
