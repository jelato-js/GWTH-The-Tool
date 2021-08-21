extends HBoxContainer
class_name ArgsBox

signal remove_args
signal change_args

onready var IdLabel : Label = $IdLabel
onready var ArgsEdit : LineEdit = $ArgsEdit
onready var RemoveArgsEdit : Button = $RemoveArgsBtn

var id : int = 0
var args : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_label()

func init(args_id :int, args_text :String = ""):
	id = args_id
	args = args_text

func _on_RemoveArgsBtn_pressed():
	emit_signal("remove_args", self)

func _on_ArgsEdit_text_changed(new_text):
	emit_signal("change_args", id, new_text)

func rearrange_id(new_id):
	id = new_id
	refresh_label()

func refresh_label():
	IdLabel.text = "Id %d :" % (id + 1)
