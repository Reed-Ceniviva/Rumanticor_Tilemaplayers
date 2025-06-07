extends ComponentBlueprint
class_name ComponentBlueprintTree

func get_part_height_ratio(part : EntityBodyPart):
	match part.get_type():
		BodyData.PartType.ARM:
			return 0.0125
		BodyData.PartType.TORSO:
			return 1.0
			
func get_part_shape_args(part_type: BodyData.PartType, height: float) -> Dictionary:
	match part_type:
		BodyData.PartType.TORSO: # Cylinder ~ r , h
			return {"r" = (height/80), "h" = height}
		BodyData.PartType.ARM: # Cone ~ r, h
			return {"r" = (height/80)*0.5, "h" = 1.0}
		_:
			push_warning("Shape args not implemented for PartType: %s" % str(part_type))
			return {}

func _init():
	comp_name = "blueprint"
