extends Entity
class_name TreeEntity

@onready var animated_sprite_2d : AnimatedSprite2D = $AnimatedSprite2D

func _init(init_pos : Vector2i = Vector2i(-1,-1)):
	var pos_comp_class = ComponentRegistry.get_component_class("PositionComponent")
	if pos_comp_class:
		add_component(pos_comp_class.new(init_pos))

func _ready():
	var health_comp_class = ComponentRegistry.get_component_class("HealthComponent")
	if health_comp_class:
		add_component(health_comp_class.new(30,30))
	add_tag("tree")
	var inv_comp_class = ComponentRegistry.get_component_class("InventoryComponent")
	if inv_comp_class:
		var inv_comp : InventoryComponent = inv_comp_class.new(3)
		for i in randi()%4:
			inv_comp.add_item(EntityRegistry.instantiate_entity("LogEntity"))
		add_component(inv_comp)
	animated_sprite_2d.play("default" + str(randi()%3 + 1))
	
func die():
	animated_sprite_2d.play("dead")
	super.die()
