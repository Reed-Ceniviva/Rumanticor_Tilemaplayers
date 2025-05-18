extends Resource
class_name task
@export var task_type: String = ""
#@export var target_position: Vector2i = Vector2i.ZERO
@export var metadata: Dictionary = {}

signal task_completed
signal task_failed(reason)

func is_complete(entity) -> bool:
	return true
	# Example: check if the entity reached the target
	#return entity.global_position.floor() == target_position

func on_start(entity):
	pass  # Optional logic when task begins

func on_finish(entity):
	emit_signal("task_completed")

func on_fail(entity, reason: String):
	emit_signal("task_failed", reason)
