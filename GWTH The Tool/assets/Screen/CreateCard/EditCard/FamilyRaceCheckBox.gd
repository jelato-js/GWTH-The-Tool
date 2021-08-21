extends CheckBox

signal toggled_checkbox

enum TYPE {
	Family,
	Race
}
var typeState : int
var textCheckBox : String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_data(typeCheckBox, textCheckBoxInput):
	typeState = typeCheckBox
	textCheckBox = textCheckBoxInput
	text = textCheckBox


func _on_FamilyRaceCheckBox_toggled(button_pressed):
	emit_signal("toggled_checkbox", self)
