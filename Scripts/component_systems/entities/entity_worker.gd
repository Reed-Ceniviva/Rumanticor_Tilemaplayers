extends Entity
class_name WorkerEntity

@onready var worker_animated_sprite_2d : AnimatedSprite2D = $defualt_worker_animated_sprite_2d

#shelter, food, water - well being
# safety
# social
# self esteem
# self actualization

func _init(init_pos : Vector2i = Vector2i(-1,-1)):
	var pos_comp_class = ComponentRegistry.get_component_class("PositionComponent")
	if pos_comp_class:
		add_component(pos_comp_class.new(init_pos))

func _ready():
	var health_comp_class = ComponentRegistry.get_component_class("HealthComponent")
	if health_comp_class:
		add_component(health_comp_class.new(100,100))
	var inv_comp_class = ComponentRegistry.get_component_class("InventoryComponent")
	if inv_comp_class:
		add_component(inv_comp_class.new(2))
	var vision_comp_class = ComponentRegistry.get_component_class("VisionComponent")
	if vision_comp_class:
		add_component(vision_comp_class.new(32))
	worker_animated_sprite_2d.play("default")

func chop():
	worker_animated_sprite_2d.play("chop")
