extends Control

signal saveCardCond

onready var itemList: VBoxContainer = $CardCondPanel/ScrollContainer/VBoxContainer

onready var commandPanelControl : Control = $CommandPanelControl

var cardConditonArrary: Array 
var cardConditonNode: Array

onready var CardConditionItem = preload("res://assets/Screen/CreateCard/EditEffect/TargetCardCondition/CardConditionItem.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	commandPanelControl.connect("saveItem", self, "_SaveCardCondItem")
	refresh()
	hide()

func refresh():
	cardConditonArrary.clear()
	for node in cardConditonNode:
		itemList.remove_child(node)
	cardConditonNode.clear()

func set_cardcondition_data(data: Array):
	refresh()
	for i in range(data.size()):
		AddCardCondItem(i, data[i])
	show()

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
	new_cardCondItem.connect("edit", self, "EditCardCondItem")
	new_cardCondItem.connect("remove", self, "RemoveCardCondItem")
	cardConditonArrary.append(new_cardCond)
	cardConditonNode.append(new_cardCondItem)

func _on_AddCardCondBtn_pressed():
	commandPanelControl.ShowPanel(CardCondition.new(), cardConditonArrary.size(), true)

func OptionalCheck(index:int, button_pressed: bool):
	cardConditonArrary[index].optional = button_pressed
	cardConditonNode[index].cardCond = cardConditonArrary[index]
	cardConditonNode[index].refresh()

func RemoveCardCondItem(index:int, node:CardConditionItem):
	cardConditonArrary.remove(index)
	cardConditonNode.erase(node)
	itemList.remove_child(node)
	node.queue_free()
	rearrange_args()

func EditCardCondItem(index:int):
	commandPanelControl.ShowPanel(cardConditonArrary[index], index, false)

func rearrange_args():
	var id = 0
	for child in cardConditonNode:
		child.rearrange_id(id)
		id += 1

func _SaveCardCondItem(data:CardCondition, indexSave:int, newItem:bool):
	if newItem:
		AddCardCondItem(indexSave, data)
	else:
		cardConditonArrary[indexSave] = data
		cardConditonNode[indexSave].cardCond = data
		cardConditonNode[indexSave].refresh()

func _on_CancelBtn_pressed():
	hide()

func _on_SaveBtn_pressed():
	emit_signal("saveCardCond", cardConditonArrary.duplicate())
	hide()
