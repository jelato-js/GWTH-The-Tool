extends HBoxContainer
class_name CostBox

signal remove_cost

onready var IndexLabel : Label = $VBoxContainer/HBoxContainer/IndexLabel

onready var CostTypeOption : OptionButton = $VBoxContainer/HBoxContainer/CostTypeOption
onready var ValueTypeOption : OptionButton = $VBoxContainer/HBoxContainer2/ValueTypeOption
onready var ForceCheckBox : CheckBox = $VBoxContainer/HBoxContainer2/ForceCheckBox

onready var AllArgsContainer : VBoxContainer = $AllArgsContainer

var id :int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	CostTypeOption.get_popup().clear()
	for cost_type in EffectData.COST_TYPE.keys():
		CostTypeOption.get_popup().add_item(cost_type)
	ValueTypeOption.get_popup().clear()
	for value_type in EffectData.VALUE_TYPE.keys():
		ValueTypeOption.get_popup().add_item(value_type)
	CostTypeOption.select(0)
	ValueTypeOption.select(0)
	refresh_label()

func init(cost_id :int, card_cost : EffectData.Cost):
	id = cost_id
	if card_cost != null:
		set_cost_data(card_cost)

func refresh_label():
	IndexLabel.text = "cost %d." % (id+1)

func get_condition_data() -> EffectData.Cost:
	var cost = EffectData.Cost.new()
	cost.type = CostTypeOption.selected
	cost.valueType = ValueTypeOption.selected
	cost.argument = AllArgsContainer.get_all_args()
	cost.force = ForceCheckBox.pressed
	return cost
	
func set_cost_data(cost : EffectData.Cost):
	CostTypeOption.selected = cost.type
	ValueTypeOption.selected = cost.valueType
	AllArgsContainer.set_all_args(cost.argument)
	ForceCheckBox.pressed = cost.force

func rearrange_id(new_id):
	id = new_id
	refresh_label()

func _on_RemoveCostBtn_pressed():
	emit_signal("remove_cost", self)
