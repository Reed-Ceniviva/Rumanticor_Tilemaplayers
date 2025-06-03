extends Resource
class_name MaterialData

enum MaterialTypes {BONE, FLESH, WOOD, WATER, IRON, GOLD, COMPOSITE}

var MaterialDensity = {
	MaterialTypes.BONE: 1200,
	MaterialTypes.FLESH: 1060,
	MaterialTypes.WOOD: 500,
	MaterialTypes.WATER: 1000,
	MaterialTypes.IRON: 7870,
	MaterialTypes.GOLD: 19300,
	}

func get_composite_density(layers : Array[MaterialTypes], ratios : Array[float] = []) -> float:
	var result = 0
	if(ratios.size() != layers.size()) or ratios.is_empty():
		print("improper ratios provided")
		for i in range(layers.size()):
			ratios[i] = 1/layers.size()
	var j = 0
	for layer in layers:
		result += MaterialDensity[layer] * ratios[j]
		j += 1
		
	return result
