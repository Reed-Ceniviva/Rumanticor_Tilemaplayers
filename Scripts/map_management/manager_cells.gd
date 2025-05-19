class_name manager_cells extends Node

##this class is needed for storing information that will not be represented by cell existence on a tilemap

# Store per-cell data here
var cell_metadata := {}

func set_cell_data(cell_pos: Vector2i, data: Dictionary) -> void:
	cell_metadata[cell_pos] = data

func get_cell_data(cell_pos: Vector2i) -> Dictionary:
	return cell_metadata.get(cell_pos, {})

func has_cell_data(cell_pos: Vector2i) -> bool:
	return cell_metadata.has(cell_pos)

func remove_cell_data(cell_pos: Vector2i) -> void:
	cell_metadata.erase(cell_pos)
