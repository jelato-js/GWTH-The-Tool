extends HBoxContainer

signal remove_texteffect

onready var IndexLabel : Label = $Label
onready var TextEffectEdit : TextEdit = $TextEdit

var id :int = 0
var text_effect :String = ""

func init(text_id, text :String = ""):
	id = text_id
	text_effect = text

# Called when the node enters the scene tree for the first time.
func _ready():
	TextEffectEdit.text = text_effect
	refresh_label()

func get_text_effect() -> String:
	return TextEffectEdit.text

func refresh_label():
	IndexLabel.text = "No.%d:" % (id+1)

func _on_Button_pressed():
	emit_signal("remove_texteffect", self)

func rearrange_id(new_id):
	id = new_id
	refresh_label()
