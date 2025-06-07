class_name EntityTree extends Entity

@onready var animated_sprite_2d = $AnimatedSprite2D
var body = EntityBody.new()

func setup(pos: Vector2i = Vector2i.ZERO):
	#give the tree a position
	add_component(ComponentPosition.new(pos))
	
	#give the tree health
	var health = ComponentHealth.new()
	health.max_health = 30
	health.current_health = 30
	add_component(health)
	
	#give the tree a body
	body.height = 1.0
	wm.new_entity_id(body)
	#give tree age
	var age = ComponentAge.new()
	add_component(age)
	
	#give the tree growth
	var growth = ComponentGrowth.new()
	growth.standing_growth = 0.33
	body.add_component(growth)
	
	#give the tree a blueprint to grow by
	var blueprint = ComponentBlueprintTree.new()
	body.add_component(blueprint)
	
	#display the tree using a random tree sprite
	var rand_tree = "default" + str(randi()%3+1)
	animated_sprite_2d.play(rand_tree)
	
	
