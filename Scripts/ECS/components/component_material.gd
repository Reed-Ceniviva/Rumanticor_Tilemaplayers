extends Component
class_name ComponentMaterial

var _MaterialData = MaterialData.new()

# Density in kg per cubic meter (kg/m³)
var material_type: MaterialData.MaterialTypes
var density: float = 1000.0  # e.g., water by default

# Optional metadata (e.g. color, burn temp, etc.)
var tags: Dictionary = {}


func _init(mat_type : MaterialData.MaterialTypes):
	comp_name = "material"
	material_type = mat_type
	density = _MaterialData.MATERIAL_DENSITY[mat_type]
