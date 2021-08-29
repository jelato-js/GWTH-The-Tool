extends HBoxContainer
class_name CardConditionItem

signal optional
signal edit
signal remove

var index: int
var cardCond: CardCondition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setdata(id:int, cardCondData:CardCondition):
	index = id
	cardCond = cardCondData

func rearrange_id(new_id:int):
	index = new_id

func _on_CheckBox_pressed():
	emit_signal("optional", index, $CheckBox.pressed)

func _on_EditBtn_pressed():
	emit_signal("edit", index, self)

func _on_RemoveBtn_pressed():
	emit_signal("remove", index, self)
