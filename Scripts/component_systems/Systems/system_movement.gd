extends System
class_name MovementSystem

func _init():
	required_components = ["PositionComponent", "MovementPathComponent"]

func process(entity: Entity) -> void:
		if not entity.has_component_type("PositionComponent"):
			return
		if not entity.has_component_type("MovementPathComponent"):
			return
		##would use the traversable values for how many steps in the path is moved per tick
		if not entity.has_component_type("MobilityComponent"):
			return

		var pos_comp := entity.get_component_by_type("PositionComponent")
		var path_comp := entity.get_component_by_type("MovementPathComponent")

		if path_comp.is_complete():
			return

		var next_pos = path_comp.get_next_position()

		# You could insert movement validation logic here if needed (e.g., check terrain passability)

		# Instantly move to next tile
		pos_comp.pos = next_pos
		path_comp.advance_step()
