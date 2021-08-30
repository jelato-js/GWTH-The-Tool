extends HBoxContainer
class_name CardConditionItem

signal optional
signal edit
signal remove

var index: int
var cardCond: CardCondition

# Called when the node enters the scene tree for the first time.
func _ready():
	cardCond = CardCondition.new()

func setdata(id:int, cardCondData: CardCondition):
	index = id
	cardCond = cardCondData
	refresh()

func rearrange_id(new_id:int):
	index = new_id

func refresh():
	$CheckBox.pressed = cardCond.optional
	var text = cardCond.get_help_text()
	$Label.text = text

func _on_CheckBox_pressed():
	emit_signal("optional", index, $CheckBox.pressed)

func _on_EditBtn_pressed():
	emit_signal("edit", index)

func _on_RemoveBtn_pressed():
	emit_signal("remove", index, self)
