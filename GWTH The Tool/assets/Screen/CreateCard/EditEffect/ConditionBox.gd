extends HBoxContainer
class_name ConditionBox

signal remove_cond

onready var IndexLabel : Label = $VBoxContainer/HBoxContainer/IndexLabel

onready var CondTypeOption : OptionButton = $VBoxContainer/HBoxContainer/CondTypeOptionButton
onready var ValueTypeOption : OptionButton = $VBoxContainer/HBoxContainer2/ValueTypeOptionButton
onready var ForceCheckBox : CheckBox = $VBoxContainer/HBoxContainer2/ForceCheckBox

onready var AllArgsContainer : VBoxContainer = $AllArgsContainer

var id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	CondTypeOption.get_popup().clear()
	for cond_type in EffectData.COND_TYPE.keys():
		CondTypeOption.get_popup().add_item(cond_type)
	ValueTypeOption.get_popup().clear()
	for value_type in EffectData.VALUE_TYPE.keys():
		ValueTypeOption.get_popup().add_item(value_type)
	CondTypeOption.select(0)
	ValueTypeOption.select(0)
	refresh_label()

func init(cond_id :int, card_condition : EffectData.Cond):
	id = cond_id
	if card_condition != null:
		set_condition_data(card_condition)

func refresh_label():
	IndexLabel.text = "cond %d." % (id+1)

func get_condition_data() -> EffectData.Cond:
	var cond = EffectData.Cond.new()
	cond.type = CondTypeOption.selected
	cond.valueType = ValueTypeOption.selected
	cond.argument = AllArgsContainer.get_all_args()
	cond.force = ForceCheckBox.pressed
	return cond
	
func set_condition_data(condition : EffectData.Cond):
	CondTypeOption.selected = condition.type
	ValueTypeOption.selected = condition.valueType
	AllArgsContainer.set_all_args(condition.argument)
	ForceCheckBox.pressed = condition.force

func rearrange_id(new_id):
	id = new_id
	refresh_label()

func _on_RemoveCondBtn_pressed():
	emit_signal("remove_cond", self)
