extends Control


onready var itemList: VBoxContainer = $CardCondPanel/ScrollContainer/VBoxContainer

onready var commandPanelControl : Control = $CommandPanelControl

var cardConditonEdit: CardCondition
var cardConditonArrary: Array 
var cardConditonNode: Array

onready var CardConditionItem = preload("res://assets/Screen/CreateCard/EditEffect/TargetCardCondition/CardConditionItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()

func refresh():
	cardConditonEdit = CardCondition.new()
	cardConditonArrary.clear()
	for node in cardConditonNode:
		remove_child(node)
	cardConditonNode.clear()

func set_cardcondition_data(data: Array):
	refresh()
	cardConditonArrary = data

func get_cardcondition_data() -> Array:
	return cardConditonArrary

func AddCardCondItem(index:int, data:CardCondition = null):
	var new_cardCondItem = CardConditionItem.instance()
	var new_cardCond
	if data == null:
		new_cardCond = CardCondition.new()
	else:
		new_cardCond = data
	new_cardCondItem.setdata(cardConditonArrary.size(), new_cardCond)
	itemList.add_child(new_cardCondItem)
	itemList.move_child(new_cardCondItem, itemList.get_child_count() - 2)
	new_cardCondItem.connect("optional", self, "OptionalCheck")
	
	cardConditonArrary.append(new_cardCond)
	cardConditonNode.append(new_cardCondItem)

func _on_AddCardCondBtn_pressed():
	#AddCardCondItem(cardConditonArrary.size())
	commandPanelControl.ShowPanel(CardCondition.new(), cardConditonArrary.size(), true)

func OptionalCheck(index:int, button_pressed: bool):
	cardConditonArrary[index].optional = button_pressed

func RemoveCardCondItem(index:int, node:CardConditionItem):
	cardConditonArrary.remove(index)
	cardConditonNode.erase(node)
	remove_child(node)
	node.queue_free()
	rearrange_args()

func EditCardCondItem(index:int, button_pressed: bool):
	cardConditonArrary[index].optional = button_pressed

func rearrange_args():
	var id = 0
	for child in cardConditonNode:
		child.rearrange_id(id)
		id += 1
