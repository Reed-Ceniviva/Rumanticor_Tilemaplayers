extends Component
class_name ComponentShape

var shape_type: int
var shape_args: Dictionary

#ShapeTypes.CUBE:
	#if args.has("a"):
#ShapeTypes.CUBOID:
	#if args.has_all(["l", "w", "h"]):
#ShapeTypes.SPHERE:
	#if args.has("r"):
#ShapeTypes.ELLIPSOID:
	#if args.has_all(["rx", "ry", "h"]):
#ShapeTypes.CYLINDER:
	#if args.has_all(["r", "h"]):
#ShapeTypes.CONE:
	#if args.has_all(["r", "h"]):
#ShapeTypes.PYRAMID:
	#if args.has_all(["A", "h"]):  # A = base area
#ShapeTypes.TORUS:
	#if args.has_all(["R", "r"]):  # R = major radius, r = tube radius
#ShapeTypes.CAPSULE:
	#if args.has_all(["r", "h"]):  # cylinder height h, spherical caps

func _init(type : ShapeData.ShapeTypes):
	comp_name = "shape"
	shape_type = type

func set_args(args : Dictionary):
	shape_args = args

func set_cube_args( a : float):
	shape_args["a"] = a

func set_cuboid_args( l : float, w : float, h : float):
	shape_args["l"] = l
	shape_args["w"] = w
	shape_args["h"] = h
	
func set_sphere_args( r : float):
	shape_args["r"] = r

func set_ellipsoid_args( rx : float, ry : float, h : float):
	shape_args["rx"] = rx
	shape_args["ry"] = ry
	shape_args["h"] = h

func set_cylinder_args( r : float, h : float):
	shape_args["r"] = r
	shape_args["h"] = h
	
func set_cone_args( r : float, h : float):
	shape_args["r"] = r
	shape_args["h"] = h

func set_pyramid_args( A : float, h : float):
	shape_args["A"] = A
	shape_args["h"] = h
	
func set_torus_args( R : float, r : float):
	shape_args["r"] = r
	shape_args["R"] = R	
	
func set_capsule_args( r : float, h : float):
	shape_args["r"] = r
	shape_args["h"] = h

func get_volume_args() -> Dictionary:
	return shape_args
