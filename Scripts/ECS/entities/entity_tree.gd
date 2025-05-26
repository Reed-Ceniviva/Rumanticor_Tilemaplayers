class_name EntityTree extends EntityBase

@onready var animated_sprite_2d = $AnimatedSprite2D

func setup(pos: Vector2i = Vector2i.ZERO):
	#give the tree a position
	add_component(ComponentPosition.new(pos))
	
	#display the tree using a random tree sprite
	var rand_tree = "default" + str(randi()%3+1)
	animated_sprite_2d.play(rand_tree)
	
	#give the tree a body 
	var body = ComponentBody.new()
	var trunk = ComponentBodyPart.new(ComponentBodyPart.PartType.TORSO, ComponentBodyPart.PartSide.CENTER, ComponentBodyPart.PartLevel.ALL)
	body.add_part(trunk, body)
