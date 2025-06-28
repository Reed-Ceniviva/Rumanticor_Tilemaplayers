extends Node2D
class_name FortressMode

var fortress_layer_manager : layer_manager
var tick_counter = 0.0
var tick_duration = 0.33

var health_system = HealthSystem.new()
var pos_system = PositionSystem.new()
var entities_layer

func _on_texture_button_pressed():
	pass # Replace with function body.

func _physics_process(delta):
	if fortress_layer_manager == null:
		for child in get_children():
			if child is layer_manager:
				fortress_layer_manager = child
		if fortress_layer_manager != null:
			entities_layer = fortress_layer_manager.tm_layers["entities"]
			pos_system.groundTM = fortress_layer_manager.tm_layers["ground"]
			print("layer manager assigned")
	else:
		tick_counter -= delta
		if tick_counter <= 0.0:
			tick_counter+=tick_duration
		for child in entities_layer.get_children():
			if child is Entity:
					#print(child.get_component_by_type("AvailableActionsComponent").actions)
				if child.has_component_type("HealthComponent"):
					#print("calling health system")
					health_system.process(child)
				if child.has_component_type("PositionComponent"):
					#print("calling position system")
					pos_system.process(child)
				#if child.has_component_type("BrainComponent"):
					#var brain : BrainComponent = child.get_component_by_type("BrainComponent")
					#intent_propagator.process(child)
					#var intent = brain.recall("intent", "rest")
					#
					#print("intent: " , intent)
					#
					#if brain.knows("in_sight"):
						#vision_system.process(child)
					#if brain.knows("current_path"):
						#movement_system.process(child)
