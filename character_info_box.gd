extends Control

@onready var name_label = $CanvasLayer/MarginContainer/Panel/GridContainer/Name_Label

@onready var activity_label = $CanvasLayer/MarginContainer/Panel/GridContainer/Activity_Label

@onready var wis_v_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/Wesnail_Sliders_HBoxContainer/Wis_VSlider
@onready var extro_v_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/Wesnail_Sliders_HBoxContainer/Extro_VSlider
@onready var strength_v_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/Wesnail_Sliders_HBoxContainer/Strength_VSlider
@onready var nature_v_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/Wesnail_Sliders_HBoxContainer/Nature_VSlider
@onready var art_v_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/Wesnail_Sliders_HBoxContainer/Art_VSlider
@onready var inspo_v_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/Wesnail_Sliders_HBoxContainer/Inspo_VSlider
@onready var luck_v_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/Wesnail_Sliders_HBoxContainer/Luck_VSlider

@onready var thoughts_text_edit = $CanvasLayer/MarginContainer/Panel/GridContainer/Thoughts_TextEdit

@onready var hp_h_slider = $CanvasLayer/MarginContainer/Panel/GridContainer/HP_HBoxContainer/HP_HSlider



func _init(character : Entity):
	if character.has_component_type("SphereStatsComponent"):
		var sphere_stats_comp : SphereStatsComponent = character.get_component_by_type("SphereStatsComponent")
		var sphere_stats = sphere_stats_comp.stats
		wis_v_slider.value = sphere_stats["Wisdom"]
		extro_v_slider.value = sphere_stats["Social"]
		strength_v_slider.value = sphere_stats["Strength"]
		nature_v_slider.value = sphere_stats["Nature"]
		art_v_slider.value = sphere_stats["Art"]
		inspo_v_slider.value = sphere_stats["Inspiration"]
		luck_v_slider.value = sphere_stats["Luck"]
	
	if character.has_component_type("HealthComponent"):
		var health_comp : HealthComponent = character.get_component_by_type("HealthComponent")
		hp_h_slider.value = health_comp.current_health
	
	if character.has_component_type("BrainComponent"):
		var brain_comp : BrainComponent = character.get_component_by_type("BrainComponent")
		if brain_comp.knows("name"):
			name_label.text = brain_comp.recall("name", "unknown")
		
	
