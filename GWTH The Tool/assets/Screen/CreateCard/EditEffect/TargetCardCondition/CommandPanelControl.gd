extends Control

onready var tabContainer : TabContainer = $AddCondPanel/TabContainer
onready var optionalCheckBox : CheckBox = $AddCondPanel/OptionalCheckBox

#-----------------
onready var PlayerCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/PlayerCheckBox"
onready var PVariableCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/CheckBox"
onready var PVConstantCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Constant/CheckBox"
onready var PVOpponentCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Opponent/CheckBox"
onready var PVLMCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/LM/CheckBox"

onready var PVNumberOptionBtn : OptionButton = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Number/OptionButton"
onready var PVOperatorOptionBtn: OptionButton = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Number/OperatorValue"
onready var PVConstantSpinBox: SpinBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Constant/SpinBox"
onready var PVOpponentOptionBtn: OptionButton = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Opponent/OptionButton"
onready var PVLMLineEdit: LineEdit = $"AddCondPanel/TabContainer/1/Content/Variable/Value/LM/LineEdit"

onready var PHaveCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Have/CheckBox"
onready var PHaveLineEdit: LineEdit = $"AddCondPanel/TabContainer/1/Content/Have/LineEdit"
#-----------------
onready var CardCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/CardCheckBox"
onready var CIdCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Id/CheckBox"
onready var CIdLineEdit: LineEdit = $"AddCondPanel/TabContainer/2/Content/Id/LineEdit"

onready var CVariableCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Variable/CheckBox"
onready var CVNumberOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Number/OptionButton"
onready var CVOperatorOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Number/OperatorValue"
onready var CVConstantCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Constant/CheckBox"
onready var CVConstantSpinbox: SpinBox = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Constant/SpinBox"
onready var CVLMCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Variable/Value/LM/CheckBox"
onready var CVLMLineEdit: LineEdit = $"AddCondPanel/TabContainer/2/Content/Variable/Value/LM/LineEdit"

onready var CFamilyCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Family/CheckBox"
onready var CFamilyOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Family/OptionButton"
onready var CRaceCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Race/CheckBox"
onready var CRaceOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Race/OptionButton"
onready var CElementCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Element/CheckBox"
onready var CElementOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Element/OptionButton"
onready var CSpecialCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Special/CheckBox"
onready var CSpecialOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Special/OptionButton"

#-----------------

var cardCondEditing: CardCondition
var index: int
var adding: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	PVOperatorOptionBtn.get_popup().clear()
	CVOperatorOptionBtn.get_popup().clear()
	for i in EnumData.OperatorValue():
		PVOperatorOptionBtn.get_popup().add_radio_check_item(EnumData.OperatorValue()[i], i)
		CVOperatorOptionBtn.get_popup().add_radio_check_item(EnumData.OperatorValue()[i], i)
	PVNumberOptionBtn.get_popup().clear()
	PVOpponentOptionBtn.get_popup().clear()
	for i in EnumData.PlayerAttributeCond:
		PVNumberOptionBtn.get_popup().add_radio_check_item(i)
		PVOpponentOptionBtn.get_popup().add_radio_check_item(i)
	CVNumberOptionBtn.get_popup().clear()
	for i in EnumData.CardAttributeCond:
		CVNumberOptionBtn.get_popup().add_radio_check_item(i)
	CElementOptionBtn.get_popup().clear()
	for i in CardData.CARD_ELEMENT:
		CElementOptionBtn.get_popup().add_radio_check_item(i)
	CSpecialOptionBtn.get_popup().clear()
	for i in EnumData.CardSpecialCond:
		CSpecialOptionBtn.get_popup().add_radio_check_item(i)
	hide()

func ShowPanel(data: CardCondition, index:int = 0, new: bool = false):
	adding = new
	cardCondEditing = data
	optionalCheckBox.pressed = cardCondEditing.optional
	match(cardCondEditing.conditionType):
		CardCondition.ConditionType.Player:
			tabContainer.current_tab = 0
			PlayerCheckBox.pressed = true
			match(cardCondEditing.conditionWhat):
				CardCondition.PlayerCondidionType.Variable:
					PVariableCheckBox.pressed = true
					PVNumberOptionBtn.selected = cardCondEditing.variableCond.number1
					PVOperatorOptionBtn.selected = cardCondEditing.variableCond.operator
					match(cardCondEditing.variableCond.checkType):
						EnumData.NumberValueType.Constant:
							PVConstantCheckBox.pressed = true
							PVConstantSpinBox.value = cardCondEditing.variableCond.number2
						EnumData.NumberValueType.Opponent:
							PVOpponentCheckBox.pressed = true
							PVOpponentOptionBtn.value = cardCondEditing.variableCond.number2
						EnumData.NumberValueType.LM:
							PVLMCheckBox.pressed = true
							PVLMLineEdit.text = cardCondEditing.variableCond.variableName
				CardCondition.PlayerCondidionType.Have:
					PHaveCheckBox.pressed = true
					PHaveLineEdit.text = cardCondEditing.variableCond.cardId
		CardCondition.ConditionType.Card:
			tabContainer.current_tab = 1
	show()
