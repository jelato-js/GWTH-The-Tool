extends Control

onready var methodOptionBtn : OptionButton = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/MethodOptionBtn

onready var FromConstantCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/FromContainer/Value/ConstantContainer/CheckBox
onready var FromConstantSpinBox : SpinBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/FromContainer/Value/ConstantContainer/SpinBox
onready var FromLMCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/FromContainer/Value/LocalMemContainer/CheckBox
onready var FromLMLineEdit : LineEdit = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/FromContainer/Value/LocalMemContainer/LineEdit
onready var FromSpecialCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/FromContainer/Value/SpecialContainer/CheckBox

onready var ToConstantCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/ToContainer/Value/ConstantContainer/CheckBox
onready var ToConstantSpinBox : SpinBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/ToContainer/Value/ConstantContainer/SpinBox
onready var ToLMCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/ToContainer/Value/LocalMemContainer/CheckBox
onready var ToLMLineEdit : LineEdit = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/ToContainer/Value/LocalMemContainer/LineEdit
onready var ToSpecialCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/MethodContainer/ToContainer/Value/SpecialContainer/CheckBox

onready var SelfCheckBox: CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/TargetContainer/CheckBox
onready var Player1CheckBox: CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/TargetContainer/CheckBox2
onready var Player2CheckBox: CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/TargetContainer/CheckBox3
onready var HollowCheckBox: CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/TargetContainer/CheckBox4
onready var MagicCheckBox: CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/TargetContainer/CheckBox5
onready var AreaCheckBox: CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/TargetContainer/CheckBox6

onready var AnywhereCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/CheckBox
onready var FieldCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Field/CheckBox
onready var FieldP1CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Field/CheckBoxP1
onready var FieldP2CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Field/CheckBoxP2
onready var HandCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Hand/CheckBox
onready var HandP1CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Hand/CheckBoxP1
onready var HandP2CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Hand/CheckBoxP2
onready var DeckCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Deck/CheckBox
onready var DeckP1CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Deck/CheckBoxP1
onready var DeckP2CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Deck/CheckBoxP2
onready var AbyssCheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Abyss/CheckBox
onready var AbyssP1CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Abyss/CheckBoxP1
onready var AbyssP2CheckBox : CheckBox = $EditTargetPanel/PanelContainer/ContentContainer/WhereContainer/Abyss/CheckBoxP2

enum TargetType {
	FromValue,
	ToValue,
	TargetValue,
	WhereValue
}
enum TargetWhere {
	Anywhere,
	Field,
	Hand,
	Deck,
	Abyss,
	P1,
	P2
}

var target:Target = Target.new()

onready var CardCondItemList: ItemList = $EditTargetPanel/ScrollContainer/ItemList
onready var CardConditionControl : Control = $CardConditionControl

# Called when the node enters the scene tree for the first time.
func _ready():
	methodOptionBtn.get_popup().clear()
	for i in EnumData.TargetMethod:
		methodOptionBtn.get_popup().add_item(i)
	
	NodeEnableControl(false, TargetType.FromValue)
	NodeEnableControl(false, TargetType.ToValue)
	NodeEnableControl(false, TargetType.TargetValue)
	NodeEnableControl(false, TargetType.WhereValue)
	
	FromConstantCheckBox.connect("pressed", self, "_FromToNodeEnable")
	FromLMCheckBox.connect("pressed", self, "_FromToNodeEnable")
	ToConstantCheckBox.connect("pressed", self, "_FromToNodeEnable")
	ToLMCheckBox.connect("pressed", self, "_FromToNodeEnable")
	
	var TargetNode = get_tree().get_nodes_in_group("TargetValue")
	for checkBox in TargetNode:
		checkBox.connect("pressed", self, "_WhereEnableTargetUpdate")
	
	AnywhereCheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Anywhere, AnywhereCheckBox])
	FieldCheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Field, FieldCheckBox])
	FieldP1CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Field, FieldP1CheckBox, TargetWhere.P1])
	FieldP2CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Field, FieldP2CheckBox, TargetWhere.P2])
	HandCheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Hand, HandCheckBox])
	HandP1CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Hand, HandP1CheckBox, TargetWhere.P1])
	HandP2CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Hand, HandP2CheckBox, TargetWhere.P2])
	DeckCheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Deck, DeckCheckBox])
	DeckP1CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Deck, DeckP1CheckBox, TargetWhere.P1])
	DeckP2CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Deck, DeckP2CheckBox, TargetWhere.P2])
	AbyssCheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Abyss, AbyssCheckBox])
	AbyssP1CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Abyss, AbyssP1CheckBox, TargetWhere.P1])
	AbyssP2CheckBox.connect("pressed", self, "_WhereNodeEnable", [TargetWhere.Abyss, AbyssP2CheckBox, TargetWhere.P2])
	
	CardConditionControl.connect("saveCardCond", self, "_saveCardCond")

func NodeEnableControl(enable: bool, type: int):
	var groupName = TargetType.keys()[type]
	var nodeDisable = get_tree().get_nodes_in_group(groupName)
	for node in nodeDisable:
		if node is CheckBox or node is OptionButton:
			node.disabled = not enable
		if node is CheckBox and node.group == null and type != TargetType.WhereValue:
			node.pressed = enable
		if type == TargetType.WhereValue and not enable:
			node.pressed = enable
		if node is SpinBox or node is LineEdit:
			node.editable = enable

func _on_MethodOptionBtn_item_selected(index):
	match(index):
		EnumData.TargetMethod.No_Target:
			NodeEnableControl(false, TargetType.FromValue)
			NodeEnableControl(false, TargetType.ToValue)
			NodeEnableControl(false, TargetType.TargetValue)
			NodeEnableControl(false, TargetType.WhereValue)
		EnumData.TargetMethod.All:
			NodeEnableControl(false, TargetType.FromValue)
			NodeEnableControl(false, TargetType.ToValue)
		EnumData.TargetMethod.Choose:
			NodeEnableControl(true, TargetType.FromValue)
			NodeEnableControl(false, TargetType.ToValue)
		EnumData.TargetMethod.Random:
			NodeEnableControl(true, TargetType.FromValue)
			NodeEnableControl(true, TargetType.ToValue)
	if index != EnumData.TargetMethod.No_Target:
		NodeEnableControl(true, TargetType.TargetValue)
		NodeEnableControl(true, TargetType.WhereValue)
	_WhereEnableTargetUpdate()
	target.method = index
	_FromToNodeEnable()

func _FromToNodeEnable():
	FromConstantSpinBox.editable = FromConstantCheckBox.pressed and not FromConstantCheckBox.disabled
	FromLMLineEdit.editable = FromLMCheckBox.pressed and not FromLMCheckBox.disabled
	ToConstantSpinBox.editable = ToConstantCheckBox.pressed and not ToConstantCheckBox.disabled
	ToLMLineEdit.editable = ToLMCheckBox.pressed and not ToLMCheckBox.disabled

func _FromSpinBoxValue_Changed(value: float):
	ToConstantSpinBox.min_value = value

func _WhereEnableTargetUpdate():
	if HollowCheckBox.pressed or MagicCheckBox.pressed or AreaCheckBox.pressed:
		NodeEnableControl(true, TargetType.WhereValue)
	else:
		NodeEnableControl(false, TargetType.WhereValue)

func _WhereNodeEnable(type: int, node: CheckBox, of = null):
	var button_pressed = node.pressed
	var nodeCheckBox: CheckBox
	var nodeP1: CheckBox
	var nodeP2: CheckBox
	var groupName = TargetType.keys()[TargetType.WhereValue]
	var nodeGroup = get_tree().get_nodes_in_group(groupName)
	match(type):
		TargetWhere.Anywhere:
			if button_pressed:
				for node in nodeGroup:
					node.pressed = true
				return
		TargetWhere.Field:
			nodeCheckBox = FieldCheckBox
			nodeP1 = FieldP1CheckBox
			nodeP2 = FieldP2CheckBox
		TargetWhere.Hand:
			nodeCheckBox = HandCheckBox
			nodeP1 = HandP1CheckBox
			nodeP2 = HandP2CheckBox
		TargetWhere.Deck:
			nodeCheckBox = DeckCheckBox
			nodeP1 = DeckP1CheckBox
			nodeP2 = DeckP2CheckBox
		TargetWhere.Abyss:
			nodeCheckBox = AbyssCheckBox
			nodeP1 = AbyssP1CheckBox
			nodeP2 = AbyssP2CheckBox
	if of == null:
		if button_pressed:
			nodeP1.pressed = true
			nodeP2.pressed = true
		else:
			nodeP1.pressed = false
			nodeP2.pressed = false
	else:
		if button_pressed:
			nodeCheckBox.pressed = true
		elif of == TargetWhere.P1 and not nodeP2.pressed:
			nodeCheckBox.pressed = false
		elif of == TargetWhere.P2 and not nodeP1.pressed:
			nodeCheckBox.pressed = false
	#-----------------
	var anywhere = true
	for node in nodeGroup:
		if node == AnywhereCheckBox:
			continue
		if not node.pressed:
			anywhere = false
			break
	AnywhereCheckBox.pressed = anywhere

func _on_TargetCondBtn_pressed():
	CardConditionControl.set_cardcondition_data(target.targetCond)

func _saveCardCond(cardCondArray: Array):
	target.targetCond = cardCondArray
	refreshCardCondList()

func refreshCardCondList():
	CardCondItemList.clear()
	for cardCond in target.targetCond:
		CardCondItemList.add_item(cardCond.get_help_text(true))

func _on_CancelBtn_pressed():
	hide()

func _on_SaveBtn_pressed():
	target.method = methodOptionBtn.selected
	if target.method == EnumData.TargetMethod.Choose or target.method == EnumData.TargetMethod.Random:
		if FromConstantCheckBox.pressed:
			target.amount.fromValue.type = EnumData.NumberValueType.Constant
			target.amount.fromValue.value = FromConstantSpinBox.value
		if FromLMCheckBox.pressed:
			target.amount.fromValue.type = EnumData.NumberValueType.LM
			target.amount.fromValue.variableName = FromLMLineEdit.text
		if FromSpecialCheckBox.pressed:
			target.amount.fromValue.type = EnumData.NumberValueType.Special
	if target.method == EnumData.TargetMethod.Random:
		if FromConstantCheckBox.pressed:
			target.amount.toValue.type = EnumData.NumberValueType.Constant
			target.amount.toValue.value = FromConstantSpinBox.value
		if FromLMCheckBox.pressed:
			target.amount.toValue.type = EnumData.NumberValueType.LM
			target.amount.toValue.variableName = FromLMLineEdit.text
		if FromSpecialCheckBox.pressed:
			target.amount.toValue.type = EnumData.NumberValueType.Special
	if target.method != EnumData.TargetMethod.No_Target:
		target.target.user = SelfCheckBox.pressed
		target.target.player1 = Player1CheckBox.pressed
		target.target.player2 = Player2CheckBox.pressed
		target.target.hollow = HollowCheckBox.pressed
		target.target.magic = MagicCheckBox.pressed
		target.target.area = AreaCheckBox.pressed
	if target.target.hollow or target.target.magic or target.target.area:
		if FieldCheckBox.pressed:
			target.where.field.check = FieldCheckBox.pressed
			target.where.field.of.player1 = FieldP1CheckBox.pressed
			target.where.field.of.player2 = FieldP2CheckBox.pressed
		if HandCheckBox.pressed:
			target.where.hand.check = HandCheckBox.pressed
			target.where.hand.of.player1 = HandP1CheckBox.pressed
			target.where.hand.of.player2 = HandP2CheckBox.pressed
		if DeckCheckBox.pressed:
			target.where.deck.check = DeckCheckBox.pressed
			target.where.deck.of.player1 = DeckP1CheckBox.pressed
			target.where.deck.of.player2 = DeckP2CheckBox.pressed
		if AbyssCheckBox.pressed:
			target.where.abyss.check = AbyssCheckBox.pressed
			target.where.abyss.of.player1 = AbyssP1CheckBox.pressed
			target.where.abyss.of.player2 = AbyssP2CheckBox.pressed
	print(var2str(target))
