extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func CallPopup(text):
	$BG.visible = true
	$AcceptDialog.dialog_text = text
	$AcceptDialog.popup_centered()


func _on_AcceptDialog_popup_hide():
	$BG.visible = false
