extends System
class_name PositionSystem

@export var groundTM : TileMapLayer


func _init():
	required_components = ["PositionComponent"]
	
	

func process(entity: Entity) -> void:
	var pos_comp : PositionComponent = entity.get_component_by_type("PositionComponent")
	if pos_comp and groundTM:
		var local_pos = groundTM.map_to_local(pos_comp.pos)
		if entity.position != local_pos:
			entity.position = local_pos
	
