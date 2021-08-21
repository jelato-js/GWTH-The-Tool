extends HBoxContainer
class_name ActBox

signal remove_act

onready var IndexLabel : Label = $VBoxContainer/IndexLabel

onready var ActTypeOption : OptionButton = $VBoxContainer2/HBoxContainer/ActTypeOption
onready var ValueTypeOption : OptionButton = $VBoxContainer2/HBoxContainer2/ValueTypeOption
onready var ForceCheckBox : CheckBox = $VBoxContainer/ForceCheckBox
onready var TargetTypeOption : OptionButton = $VBoxContainer2/HBoxContainer3/TargetTypeOption
onready var WaitCheckBox : CheckBox = $VBoxContainer/WaitCheckBox

onready var AllArgsContainer : VBoxContainer = $VBoxContainer/HBoxContainer/AllArgsContainer

var id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	ActTypeOption.get_popup().clear()
	for act_type in EffectData.ACTION_TYPE.keys():
		ActTypeOption.get_popup().add_item(act_type)
	ValueTypeOption.get_popup().clear()
	for value_type in EffectData.VALUE_TYPE.keys():
		ValueTypeOption.get_popup().add_item(value_type)
	TargetTypeOption.get_popup().clear()
	for target_type in EffectData.TARGET_TYPE.keys():
		TargetTypeOption.get_popup().add_item(target_type)
	ActTypeOption.select(0)
	ValueTypeOption.select(0)
	TargetTypeOption.select(0)
	refresh_label()

func init(act_id :int, card_act : EffectData.Action):
	id = act_id
	if card_act != null:
		set_act_data(card_act)

func refresh_label():
	IndexLabel.text = "act %d." % (id+1)

func get_act_data() -> EffectData.Action:
	var act = EffectData.Action.new()
	act.type = ActTypeOption.selected
	act.valueType = ValueTypeOption.selected
	act.argument = AllArgsContainer.get_all_args()
	act.force = ForceCheckBox.pressed
	act.targetType = TargetTypeOption.selected
	act.wait = WaitCheckBox.pressed
	return act
	
func set_act_data(act : EffectData.Action):
	ActTypeOption.selected = act.type
	ValueTypeOption.selected = act.valueType
	AllArgsContainer.set_all_args(act.argument)
	ForceCheckBox.pressed = act.force
	TargetTypeOption.selected = act.targetType
	WaitCheckBox.pressed = act.wait

func rearrange_id(new_id):
	id = new_id
	refresh_label()

func _on_RemoveActBtn_pressed():
	emit_signal("remove_act", self)
