extends System
class_name MovementSystem

func _init():
	required_components = ["PositionComponent", "MovementPathComponent","MobilityComponent"]

func process(entity: Entity) -> void:
		if not entity.has_component_type("PositionComponent"):
			return
		if not entity.has_component_type("MovementPathComponent"):
			return
		##would use the traversable values for how many steps in the path is moved per tick
		if not entity.has_component_type("BrainComponent"):
			return
		var brain_comp : BrainComponent = entity.get_component_by_type("BrainComponent")
		if not brain_comp.knows("traverses"):
			return
		if not brain_comp.knows("current_path"):
			return

		var pos_comp := entity.get_component_by_type("PositionComponent")
		var cur_path : Array[Vector2i] = brain_comp.recall("current_path", [])

		if cur_path.is_empty():
			return

		var next_pos = cur_path[0]

		# You could insert movement validation logic here if needed (e.g., check terrain passability)

		# Instantly move to next tile
		pos_comp.pos = next_pos
		brain_comp.remember("current_path", cur_path.slice(1))
