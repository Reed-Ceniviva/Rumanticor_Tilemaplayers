class_name ShapeData
extends Resource

enum ShapeTypes { CUBE, CUBOID, SPHERE, ELLIPSOID, CYLINDER, CONE, PYRAMID, TORUS, CAPSULE }

# Packing efficiency ranges (min, max) for random loose/close packing in %
const PACKING_EFFICIENCY = {
	ShapeTypes.CUBE: Vector2(52, 78),       # loose - dense
	ShapeTypes.CUBOID: Vector2(52, 78),
	ShapeTypes.SPHERE: Vector2(55, 64),
	ShapeTypes.ELLIPSOID: Vector2(68, 74),
	ShapeTypes.CYLINDER: Vector2(55, 72),
	ShapeTypes.CONE: Vector2(35, 67),
	ShapeTypes.PYRAMID: Vector2(45, 60),
	ShapeTypes.TORUS: Vector2(40, 50),
	ShapeTypes.CAPSULE: Vector2(60, 69)
}

#shapes not listed will always be subject to random packing efficiency
const ORGANIZED_PACKING_EFFICIENCY = {
	ShapeTypes.CUBE: 100,
	ShapeTypes.CYLINDER : 90,
	ShapeTypes.CONE : 79,
	ShapeTypes.PYRAMID : 85,
	ShapeTypes.ELLIPSOID: 77,
	ShapeTypes.SPHERE: 74
}

func get_organized_volume(shape_type: int, args:Dictionary):
	match shape_type:
		ShapeTypes.CUBE:
			if args.has("a"):
				var efficiency_percentage = ORGANIZED_PACKING_EFFICIENCY[ShapeTypes.CUBE]
				var efficiency = efficiency_percentage / 100.0
				return pow(args["a"], 3) / efficiency
		ShapeTypes.CUBOID:
			if args.has_all(["l", "w", "h"]):
				var efficiency_percentage = ORGANIZED_PACKING_EFFICIENCY[ShapeTypes.CUBE]
				var efficiency = efficiency_percentage / 100.0
				return args["l"] * args["w"] * args["h"] / efficiency
		ShapeTypes.SPHERE:
			if args.has("r"):
				var efficiency_percentage = ORGANIZED_PACKING_EFFICIENCY[ShapeTypes.SPHERE]
				var efficiency = efficiency_percentage / 100.0
				return (4.0 / 3.0) * PI * pow(args["r"], 3) / efficiency
		ShapeTypes.ELLIPSOID:
			if args.has_all(["rx", "ry", "rz"]):
				var efficiency_percentage = ORGANIZED_PACKING_EFFICIENCY[ShapeTypes.ELLIPSOID]
				var efficiency = efficiency_percentage / 100.0
				return (4.0 / 3.0) * PI * args["rx"] * args["ry"] * args["rz"] / efficiency
		ShapeTypes.CYLINDER:
			if args.has_all(["r", "h"]):
				var efficiency_percentage = ORGANIZED_PACKING_EFFICIENCY[ShapeTypes.CYLINDER]
				var efficiency = efficiency_percentage / 100.0
				return PI * pow(args["r"], 2) * args["h"] / efficiency
		ShapeTypes.CONE:
			if args.has_all(["r", "h"]):
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.CONE].x, PACKING_EFFICIENCY[ShapeTypes.CONE].y))
				var efficiency = efficiency_percentage / 100.0
				return (1.0 / 3.0) * PI * pow(args["r"], 2) * args["h"] / efficiency
		ShapeTypes.PYRAMID:
			if args.has_all(["A", "h"]):  # A = base area
				var efficiency_percentage = ORGANIZED_PACKING_EFFICIENCY[ShapeTypes.PYRAMID]
				var efficiency = efficiency_percentage / 100.0
				return (1.0 / 3.0) * args["A"] * args["h"] / efficiency
				
	push_warning("Insufficient parameters for volume calculation of shape type %s" % str(shape_type))
	return 0.0

func get_rand_volume(shape_type: int, args:Dictionary):
	match shape_type:
		ShapeTypes.CUBE:
			if args.has("a"):
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.CUBE].x, PACKING_EFFICIENCY[ShapeTypes.CUBE].y))
				var efficiency = efficiency_percentage / 100.0
				return pow(args["a"], 3) / efficiency
		ShapeTypes.CUBOID:
			if args.has_all(["l", "w", "h"]):
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.CUBOID].x, PACKING_EFFICIENCY[ShapeTypes.CUBOID].y))
				var efficiency = efficiency_percentage / 100.0
				return args["l"] * args["w"] * args["h"] / efficiency
		ShapeTypes.SPHERE:
			if args.has("r"):
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.SPHERE].x, PACKING_EFFICIENCY[ShapeTypes.SPHERE].y))
				var efficiency = efficiency_percentage / 100.0
				return (4.0 / 3.0) * PI * pow(args["r"], 3) / efficiency
		ShapeTypes.ELLIPSOID:
			if args.has_all(["rx", "ry", "rz"]):
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.ELLIPSOID].x, PACKING_EFFICIENCY[ShapeTypes.ELLIPSOID].y))
				var efficiency = efficiency_percentage / 100.0
				return (4.0 / 3.0) * PI * args["rx"] * args["ry"] * args["rz"] / efficiency
		ShapeTypes.CYLINDER:
			if args.has_all(["r", "h"]):
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.CYLINDER].x, PACKING_EFFICIENCY[ShapeTypes.CYLINDER].y))
				var efficiency = efficiency_percentage / 100.0
				return PI * pow(args["r"], 2) * args["h"] / efficiency
		ShapeTypes.CONE:
			if args.has_all(["r", "h"]):
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.CONE].x, PACKING_EFFICIENCY[ShapeTypes.CONE].y))
				var efficiency = efficiency_percentage / 100.0
				return (1.0 / 3.0) * PI * pow(args["r"], 2) * args["h"] / efficiency
		ShapeTypes.PYRAMID:
			if args.has_all(["A", "h"]):  # A = base area
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.PYRAMID].x, PACKING_EFFICIENCY[ShapeTypes.PYRAMID].y))
				var efficiency = efficiency_percentage / 100.0
				return (1.0 / 3.0) * args["A"] * args["h"] / efficiency
		ShapeTypes.TORUS:
			if args.has_all(["R", "r"]):  # R = major radius, r = tube radius
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.TORUS].x, PACKING_EFFICIENCY[ShapeTypes.TORUS].y))
				var efficiency = efficiency_percentage / 100.0
				return (2.0 * PI * args["R"]) * (PI * pow(args["r"], 2)) / efficiency
		ShapeTypes.CAPSULE:
			if args.has_all(["r", "h"]):  # cylinder height h, spherical caps
				var efficiency_percentage = (randf_range(PACKING_EFFICIENCY[ShapeTypes.CAPSULE].x, PACKING_EFFICIENCY[ShapeTypes.CAPSULE].y))
				var efficiency = efficiency_percentage / 100.0
				return PI * pow(args["r"], 2) * args["h"] + (4.0 / 3.0) * PI * pow(args["r"], 3) / efficiency
				
	push_warning("Insufficient parameters for volume calculation of shape type %s" % str(shape_type))
	return 0.0

func get_volume(shape_type: int, args: Dictionary) -> float:
	match shape_type:
		ShapeTypes.CUBE:
			if args.has("a"):
				return pow(args["a"], 3)
		ShapeTypes.CUBOID:
			if args.has_all(["l", "w", "h"]):
				return args["l"] * args["w"] * args["h"]
		ShapeTypes.SPHERE:
			if args.has("r"):
				return (4.0 / 3.0) * PI * pow(args["r"], 3)
		ShapeTypes.ELLIPSOID:
			if args.has_all(["rx", "ry", "h"]):
				return (4.0 / 3.0) * PI * args["rx"] * args["ry"] * args["h"]
		ShapeTypes.CYLINDER:
			if args.has_all(["r", "h"]):
				return PI * pow(args["r"], 2) * args["h"]
		ShapeTypes.CONE:
			if args.has_all(["r", "h"]):
				return (1.0 / 3.0) * PI * pow(args["r"], 2) * args["h"]
		ShapeTypes.PYRAMID:
			if args.has_all(["A", "h"]):  # A = base area
				return (1.0 / 3.0) * args["A"] * args["h"]
		ShapeTypes.TORUS:
			if args.has_all(["R", "r"]):  # R = major radius, r = tube radius
				return (2.0 * PI * args["R"]) * (PI * pow(args["r"], 2))
		ShapeTypes.CAPSULE:
			if args.has_all(["r", "h"]):  # cylinder height h, spherical caps
				return PI * pow(args["r"], 2) * args["h"] + (4.0 / 3.0) * PI * pow(args["r"], 3)
				
	push_warning("Insufficient parameters for volume calculation of shape type %s" % str(shape_type))
	return 0.0

func expand_xy_dimensions(shape_component: ComponentShape, amount: float) -> Dictionary:
	var shape_type = shape_component.shape_type
	var args = shape_component.shape_args
	
	match shape_type:
		ShapeTypes.CUBE:
			args["a"] = args.get("a", 0.0) + amount
		ShapeTypes.CUBOID:
			args["l"] = args.get("l", 0.0) + amount
			args["w"] = args.get("w", 0.0) + amount
		ShapeTypes.SPHERE, ShapeTypes.CYLINDER, ShapeTypes.CONE, ShapeTypes.CAPSULE:
			args["r"] = args.get("r", 0.0) + amount
		ShapeTypes.ELLIPSOID:
			args["rx"] = args.get("rx", 0.0) + amount
			args["ry"] = args.get("ry", 0.0) + amount
		ShapeTypes.TORUS:
			args["R"] = args.get("R", 0.0) + amount
			args["r"] = args.get("r", 0.0) + amount
		ShapeTypes.PYRAMID:
			args["x"] = args.get("x", 0.0) + amount
			args["y"] = args.get("y", 0.0) + amount
	return args

func expand_z_dimension(shape_component: ComponentShape, amount: float) -> Dictionary:
	var shape_type = shape_component.shape_type
	var args = shape_component.shape_args
	
	match shape_type:
		ShapeTypes.CUBE:
			args["a"] = args.get("a", 0.0) + amount
		ShapeTypes.CUBOID:
			args["h"] = args.get("h", 0.0) + amount
		ShapeTypes.SPHERE:
			args["r"] = args.get("r", 0.0) + amount
		ShapeTypes.ELLIPSOID:
			args["h"] = args.get("h", 0.0) + amount
		ShapeTypes.CYLINDER, ShapeTypes.CONE, ShapeTypes.CAPSULE, ShapeTypes.PYRAMID:
			args["h"] = args.get("h", 0.0) + amount
		ShapeTypes.TORUS:
			args["r"] = args.get("r", 0.0) + amount  # only affects minor radius
	return args


func get_packing_efficiency(shape_type: int) -> Vector2:
	return PACKING_EFFICIENCY.get(shape_type, Vector2(0, 0))

func get_radius_from_circumference(circumference: float) -> float:
	return circumference / (2 * PI)

func get_diameter_from_circumference(circumference : float) ->float:
	return get_radius_from_circumference(circumference)*2
