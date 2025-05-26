class_name ComponentAnimatedSprite extends Node

@onready var _animated_sprite_2d : AnimatedSprite2D = $"."

var animation_names : Array[String]

func _ready():
	animation_names = _animated_sprite_2d.sprite_frames.get_animation_names()
		
