extends Control
class_name CharacterCreator

@onready var name_line_edit = $CanvasLayer/Panel/Name_Margin_Container/Panel2/GridContainer/Name_LineEdit

@onready var strength_label = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Strength_Label
@onready var strength_h_slider = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Strength_HSlider
@onready var nature_label = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Nature_Label
@onready var nature_h_slider = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Nature_HSlider
@onready var art_label = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Art_Label
@onready var art_h_slider = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Art_HSlider
@onready var social_label = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Social_Label
@onready var social_h_slider = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Social_HSlider
@onready var inspo_label = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Inspo_Label
@onready var inspo_h_slider = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Inspo_HSlider
@onready var luck_label = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Luck_Label
@onready var luck_h_slider = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Luck_HSlider
@onready var wisdom_label = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Wisdom_Label
@onready var wisdom_h_slider = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer/Wisdom_HSlider

@onready var human_button = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer2/Human_Button
@onready var dwarf_button = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer2/Dwarf_Button
@onready var elf_button = $CanvasLayer/Panel/Sphere_Stats_Margin_Container/Panel/GridContainer2/Elf_Button

@onready var weight_h_slider = $CanvasLayer/Panel/Height_Weight_Margin_Container/Panel/VBoxContainer/Weight_HSlider
@onready var weight_label = $CanvasLayer/Panel/Height_Weight_Margin_Container/Panel/VBoxContainer/Weight_Label
@onready var height_v_slider = $CanvasLayer/Panel/Height_Weight_Margin_Container/Panel/VBoxContainer/Height_VSlider
@onready var height_label = $CanvasLayer/Panel/Height_Weight_Margin_Container/Panel/VBoxContainer/Height_Label

@onready var age_line_edit = $CanvasLayer/Panel/Age_Margin_Container/Panel/HBoxContainer/Age_LineEdit

@onready var submit_button = $CanvasLayer/Panel/Submit_Button

signal char_submitted

var species = "human"
var age = 0
var char_name = ""

func _process(delta):
	strength_label.text = str("Strength: ", strength_h_slider.value)
	nature_label.text = str("Nature: ", nature_h_slider.value)
	art_label.text = str("Art: ", art_h_slider.value)
	social_label.text = str("Social: ", social_h_slider.value)
	inspo_label.text = str("Inspiration: " , inspo_h_slider.value)
	luck_label.text = str("Luck: " , luck_h_slider.value)
	wisdom_label.text = str("Wisdom: ", wisdom_h_slider.value)
	weight_label.text = str(weight_h_slider.value, " kg")
	height_label.text = str(height_v_slider.value, " cm")


func _on_age_line_edit_text_changed(new_text : String):
	if is_all_digits(new_text):
		age = int(new_text)
	else:
		age_line_edit.text = "00"

func is_all_digits(s: String) -> bool:
	return s != "" and s.is_subsequence_of("0123456789".repeat(s.length()))


func _on_submit_button_pressed():
	char_submitted.emit({
		"name" : char_name,
		"age" : age,
		"species": species,
		"height" : height_v_slider.value,
		"weight" : weight_h_slider.value,
		"strength": strength_h_slider.value,
		"nature": nature_h_slider.value,
		"art": art_h_slider.value,
		"social":social_h_slider.value,
		"inspo":inspo_h_slider.value,
		"luck":luck_h_slider.value,
		"wisdom":wisdom_h_slider.value
	})
	self.queue_free()


func _on_name_line_edit_text_changed(new_text):
	char_name = new_text


func _on_human_button_pressed():
	species = "human"


func _on_dwarf_button_pressed():
	species = "dwarf"


func _on_elf_button_pressed():
	species = "elf"
