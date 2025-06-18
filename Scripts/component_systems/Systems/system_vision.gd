extends System
class_name VisionSystem

func _init():
	required_components = ["VisionComponent", "PositionComponent"]


func process(entity: Entity) -> void:
	if entity.has_component_type("VisionComponent"):
		var vision : VisionComponent = entity.get_component_by_type("VisionComponent")
		var pos_viewer: Vector2 = entity.get_component_by_type("PositionComponent").pos

		vision.clear_vision()

		for target in EntityRegistry._entity_store.values():
			if target.entity_id == entity.entity_id:
				continue
			if not target.has_component_type("PositionComponent"):
				continue

			var pos_target: Vector2 = target.get_component_by_type("PositionComponent").pos
			if pos_viewer.distance_to(pos_target) <= vision.range:
				vision.add_visible_entity(target.entity_id)
		print(vision.visible_entities)
