extends HBoxContainer
class_name EffectBox

signal remove_effect

onready var EffectIndexLabel : Label = $Label
onready var EffectLabelEdit : LineEdit = $VBoxContainer/EffectInfoContainer/EffectLabelEdit
onready var RemoveEffectBtn : Button = $VBoxContainer/EffectInfoContainer/RemoveEffectBtn

onready var CondContainer : VBoxContainer = $VBoxContainer/AllCondContainer/ConditionContainer
onready var CostContainer : VBoxContainer = $VBoxContainer/AllCostContainer/CostContainer
onready var ActContainer : VBoxContainer = $VBoxContainer/AllActionContainer/ActionContainer

var id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh_label()

func init(effect_id :int, card_effect : EffectData = null):
	id = effect_id
	if card_effect != null:
		set_effect_data(card_effect)

func get_effect_label() -> String:
	return EffectLabelEdit.text
func get_all_cond() -> Array:
	return CondContainer.get_all_cond_data()
func get_all_cost() -> Array:
	return CostContainer.get_all_cost_data()
func get_all_act() -> Array:
	return ActContainer.get_all_act_data()

func set_effect_data(effect_data :EffectData):
	EffectLabelEdit.text = effect_data.effectLabel
	CondContainer.set_all_cond_data(effect_data.condition)
	CostContainer.set_all_cost_data(effect_data.cost)
	ActContainer.set_all_act_data(effect_data.action)

func refresh_label():
	EffectIndexLabel.text = "E%d :" % (id+1)

func rearrange_id(new_id):
	id = new_id
	refresh_label()

func _on_RemoveEffectBtn_pressed():
	emit_signal("remove_effect", self)
