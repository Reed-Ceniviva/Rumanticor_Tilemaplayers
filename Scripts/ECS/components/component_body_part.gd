# component_body_part.gd
class_name ComponentBodyPart
extends ComponentBody  # Now inherits body logic

var type: PartType
var side: PartSide
#var face: PartFace
var level: PartLevel
var isJoint: bool
var isLimb : bool
var isExtremity : bool
var isSensory: bool
var isMobile: bool

#max speed with only 2 full arms: 100m/25sec ~ 4meters/second (zion clark)
#max speed with 2 full legs bipedal human 10.44meters/second (usain bolt)
#max speed with 2 legs no knees: 7meters/second (Cullen Adams)
#max speed while crawling (human): 1.47meters/second (average 0.5m/s)

func _init(p_type: PartType, p_side : PartSide, p_level : PartLevel):
	comp_name = "bodypart"
	type = p_type
	side = p_side
	level = p_level
