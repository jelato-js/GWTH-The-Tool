extends HBoxContainer

signal remove_container

onready var TextLabel : Label = $Label
onready var DelBtn : Button = $Button

enum TYPE {
	Family,
	Race
}
var typeState : int
var textLabel : String

func set_data(typeLabel : int = 0, textLabelInput : String = ""):
	typeState = typeLabel
	textLabel = textLabelInput
	TextLabel.text = textLabel

func get_label_name() -> String:
	return textLabel

func _on_Button_pressed():
	emit_signal("remove_container", self)
