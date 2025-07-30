extends ColorRect

const CHARACTER_INFO_BOX = preload("uid://6hqooighp3w8")


func _on_mouse_entered():
	var char_info = CHARACTER_INFO_BOX.instantiate()
	get_parent().add_child(char_info)
	char_info.setup(get_parent())
	


func _on_mouse_exited():
	for child in get_parent().get_children():
		if child is CharacterInfoBox:
			child.queue_free()

#func _unhandled_input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#
		#else:
#
		#selection_end = world_to_map(event.position)
