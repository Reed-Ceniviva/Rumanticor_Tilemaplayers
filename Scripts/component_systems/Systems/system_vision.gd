extends System
class_name VisionSystem

func _init():
	required_components = ["VisionComponent", "PositionComponent"]


func process(entity: Entity) -> void:
	if entity.has_component_type("BrainComponent"):
		var brain : BrainComponent = entity.get_component_by_type("BrainComponent")
		var pos_viewer: Vector2 = entity.get_component_by_type("PositionComponent").pos

		brain.remember("in_sight", [])
		var sight : Array[int] = []
		for target in EntityRegistry._entity_store.values():
			if target.entity_id == entity.entity_id:
				continue
			if not target.has_component_type("PositionComponent"):
				continue

			var pos_target: Vector2 = target.get_component_by_type("PositionComponent").pos
			if pos_viewer.distance_to(pos_target) <= brain.recall("sight_range",1):
				sight.append(target.entity_id)
		brain.remember("in_sight",sight)
