extends TabContainer

#----------------
onready var CardIdEdit : LineEdit = $Info/CardIdEdit

onready var CardNameEdit : LineEdit = $Info/CardNameEdit
onready var FamilyCardEdit : Control = $Info/FamilyRaceCardEdit
onready var CardTypeOption : OptionButton = $Info/CardTypeOptionButton

onready var RaceCardEdit : Control = $Info/FamilyRaceCardEdit2
onready var ElementOption : OptionButton = $Info/ElementOptionButton
onready var GradeBox : SpinBox = $Info/GradeSpinBox
onready var ATKBox : SpinBox = $Info/ATKSpinBox
onready var HPBox : SpinBox = $Info/HPSpinBox

onready var MagicTypeOption : OptionButton = $Info/MagicTypeOptionButton
onready var AreaTurnBox : SpinBox = $Info/AreaTurnSpinBox

onready var AlternativeCheckBox : CheckBox = $Info/AlternativeCheckBox
onready var RealCardIdEdit : LineEdit = $Info/RealCardIdEdit
#----------------
onready var EffectContainer : VBoxContainer = $Effect/ScrollContainer/EffectContainer
#----------------

onready var DescTextEdit : TextEdit = $Text/HBoxContainer/VBoxContainer/DescTextEdit
onready var FlavorTextEdit : TextEdit = $Text/HBoxContainer/VBoxContainer/FlavorTextEdit
onready var ArtistLineEdit : LineEdit = $Text/HBoxContainer/VBoxContainer/ArtistLineEdit

onready var TextEffectContainer : VBoxContainer = $Text/HBoxContainer/VBoxContainer2/ScrollContainer/TextEffectContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	CardTypeOption.get_popup().clear()
	for card_type in CardData.CARD_TYPE.keys():
		CardTypeOption.get_popup().add_item(card_type)
	ElementOption.get_popup().clear()
	for element in CardData.CARD_ELEMENT.keys():
		ElementOption.get_popup().add_item(element)
	MagicTypeOption.get_popup().clear()
	for magic_type in CardData.CARD_MAGIC_TYPE.keys():
		MagicTypeOption.get_popup().add_item(magic_type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
 

func set_mod_familyrace(mod_card : ModClass.ModCard):
	FamilyCardEdit.set_mod_familyrace(mod_card.Family)
	RaceCardEdit.set_mod_familyrace(mod_card.Race)

func set_card_data(card_editing : CardData):
	#-----
	CardIdEdit.text = card_editing.cardId
	#-----
	CardNameEdit.text = card_editing.cardName
	CardTypeOption.selected = card_editing.cardType
	FamilyCardEdit.set_card_familyrace(card_editing.cardFamily)
	RaceCardEdit.set_card_familyrace(card_editing.cardRace)
	ElementOption.selected = card_editing.cardElement
	GradeBox.value = card_editing.cardGrade
	ATKBox.value = card_editing.cardAtk
	HPBox.value = card_editing.cardHP
	MagicTypeOption.selected = card_editing.cardMagicType
	AreaTurnBox.value = card_editing.cardAreaTurn
	AlternativeCheckBox.pressed = card_editing.cardAlternative
	RealCardIdEdit.text = card_editing.cardRealId
	refresh_card_info_cardtype()
	refresh_card_alt()
	#----
	EffectContainer.set_effect_catd_data(card_editing.cardEffect)
	#----
	DescTextEdit.text = card_editing.cardDescription
	FlavorTextEdit.text = card_editing.cardFlavor
	ArtistLineEdit.text = card_editing.cardArtist
	TextEffectContainer.set_all_text_effect_data(card_editing.cardEffectText)

func get_card_data() -> CardData:
	var card_edit = CardData.new()
	card_edit.cardId = CardIdEdit.text
	card_edit.cardName = CardNameEdit.text
	card_edit.cardFamily = FamilyCardEdit.get_card_familyrace()
	card_edit.cardType = CardTypeOption.selected
	match card_edit.cardType:
		CardData.CARD_TYPE.Hollow:
			card_edit.cardRace = RaceCardEdit.get_card_familyrace()
			card_edit.cardGrade = GradeBox.value
			card_edit.cardAtk = ATKBox.value
			card_edit.cardHP = HPBox.value
		CardData.CARD_TYPE.Magic:
			card_edit.cardMagicType = MagicTypeOption.selected
		CardData.CARD_TYPE.Aera:
			card_edit.cardAreaTurn = AreaTurnBox.value
	card_edit.cardAlternative = AlternativeCheckBox.pressed
	if card_edit.cardAlternative:
		card_edit.cardRealId = RealCardIdEdit.text
	else:
		card_edit.cardRealId = CardIdEdit.text
	card_edit.cardEffect = EffectContainer.get_effect_card_data()
	card_edit.cardDescription = DescTextEdit.text
	card_edit.cardFlavor = FlavorTextEdit.text
	card_edit.cardArtist = ArtistLineEdit.text
	card_edit.cardEffectText = TextEffectContainer.get_all_text_effect_data()
	return card_edit

func refresh_card_info_cardtype():
	RaceCardEdit.set_enable(false)
	ElementOption.disabled = true
	GradeBox.editable = false
	ATKBox.editable = false
	HPBox.editable = false
	MagicTypeOption.disabled = true
	AreaTurnBox.editable = false
	if CardTypeOption.selected == CardData.CARD_TYPE.Hollow:
		RaceCardEdit.set_enable(true)
		ElementOption.disabled = false
		GradeBox.editable = true
		ATKBox.editable = true
		HPBox.editable = true
	if CardTypeOption.selected == CardData.CARD_TYPE.Magic:
		MagicTypeOption.disabled = false
	if CardTypeOption.selected == CardData.CARD_TYPE.Aera:
		AreaTurnBox.editable = true

func refresh_card_alt():
	RealCardIdEdit.editable = AlternativeCheckBox.pressed

func _on_CardTypeOptionButton_item_selected(index):
	refresh_card_info_cardtype()

func _on_AlternativeCheckBox_toggled(button_pressed):
	refresh_card_alt()
