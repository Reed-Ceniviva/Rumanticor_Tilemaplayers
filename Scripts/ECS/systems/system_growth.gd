extends System
class_name SystemGrowth

const ShapeData = preload("uid://c3aevfujto4dy")
var _ShapeData : ShapeData
var year_of_ticks = 105120.0

func _init():
	_ShapeData = ShapeData.new()

func grow(entity : Entity):
	if !entity.has_component("growth"):
		print("entity does not have growth component")
		return false
	if !entity.has_component("blueprint"):
		print("entity does not have blueprint component")
		return false
	#if !entity.has_component("age"):
		#return false
	if entity is EntityBody:
		var growth_speed = entity.get_component("growth").standing_growth
		var body_height = entity.height
		for part in entity.connection_data:
			if part.has_component("shape"):
				var height_ratio = entity.Blueprint.get_part_height_ratio(part)
				_ShapeData.expand_z_dimension(part.get_component("shape"),((height_ratio*growth_speed)/year_of_ticks))
				print(part.get_component("shape").shape_args)
			if !entity.connection_data[part].is_empty():
				for sub_part in part:
					if sub_part.has_component("shape"):
						var height_ratio = entity.Blueprint.get_part_height_ratio(sub_part)
						_ShapeData.expand_z_dimension(sub_part.get_component("shape"),((height_ratio*growth_speed)/year_of_ticks))
						print(sub_part.get_component("shape").shape_args)
