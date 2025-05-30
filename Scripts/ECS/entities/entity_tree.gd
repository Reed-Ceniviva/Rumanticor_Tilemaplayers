class_name EntityTree extends Entity

@onready var animated_sprite_2d = $AnimatedSprite2D

func setup(pos: Vector2i = Vector2i.ZERO):
	#give the tree a position
	add_component(ComponentPosition.new(pos))
	
	#give the tree health
	var health = ComponentHealth.new()
	health.max_health = 30
	health.current_health = 30
	add_component(health)
	
	#display the tree using a random tree sprite
	var rand_tree = "default" + str(randi()%3+1)
	animated_sprite_2d.play(rand_tree)
	
