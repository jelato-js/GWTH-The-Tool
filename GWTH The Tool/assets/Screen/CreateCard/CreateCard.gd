extends Control

onready var ModOptionBtn : OptionButton = $CreateCardPanel/CardListControl/ModOptionButton
onready var CardItemList : ItemList = $CreateCardPanel/CardListControl/CardItemList
onready var NewCardBtn : Button = $CreateCardPanel/CardListControl/NewCardBtn
onready var EditFamilyRaceBtn : Button = $CreateCardPanel/CardListControl/EditFamilyRaceBtn
onready var DeleteMultiBtn : Button = $CreateCardPanel/CardListControl/DeleteMultiBtn
onready var DeleteCardBtn : Button = $CreateCardPanel/CardListControl/DeleteCardBtn

onready var TabCardEdit : TabContainer = $CreateCardPanel/EditCardTabContainer

onready var SaveBtn : Button = $CreateCardPanel/SaveBtn
onready var CloseBtn : Button = $CreateCardPanel/CloseBtn
onready var SaveAndCloseBtn : Button = $CreateCardPanel/SaveAndCloseBtn

#--------------------
# NewCard
onready var NewCardControl : Control = $NewCardControl
onready var NewCardIdEdit : LineEdit = $NewCardControl/Panel/NewCardIdEdit
onready var NewCardConfirmBtn : Button = $NewCardControl/Panel/NewCardConfirmBtn
onready var NewCardCancelBtn : Button = $NewCardControl/Panel/NewCardCancelBtn
#--------------------
# Edit Family Race
onready var EditFamilyRace_Control : Control = $EditFamilyRaceControl
onready var EditFamilyRace_SaveBtn : Button = $EditFamilyRaceControl/Panel/SaveBtn
onready var EditFamilyRace_CloseBtn : Button = $EditFamilyRaceControl/Panel/CloseBtn
onready var EditFamilyRace_SaceAndCloseBtn : Button = $EditFamilyRaceControl/Panel/SaveAndCloseBtn

onready var EditFamily : Control = $EditFamilyRaceControl/FamilyRaceEdit
onready var EditRace : Control = $EditFamilyRaceControl/FamilyRaceEdit2
#--------------------
onready var DelCanCel : Button = $CreateCardPanel/CardListControl/DelCancelBtn
onready var DelConfirm : Button = $CreateCardPanel/CardListControl/DelConfirmBtn

var mod_selected : ModClass.Mod = null

var all_card_id = []

var card_selected : CardData = null
var card_selected_index :int = 0

var deleting_multi :bool = false
var card_selected_id_temp :String = "" # return CardItemList to this index after done some action

# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayModOption()
	NewCardControl.hide()
	EditFamilyRace_Control.hide()

func DisplayModOption():
	ModOptionBtn.clear()
	ModOptionBtn.add_item("<Please Select Mod>")
	ModOptionBtn.set_item_disabled(0, true)
	for mod_name in Mods.all_mod_id:
		ModOptionBtn.add_item(mod_name)
	RefreshCardListControl()
	RefreshCardEditControl()

func RefreshCardListControl():
	if mod_selected == null:
		CardItemList.clear()
		NewCardBtn.disabled = true
		EditFamilyRaceBtn.disabled = true
		DeleteMultiBtn.disabled = true
		DeleteCardBtn.disabled = true
	else:
		CardItemList.clear()
		all_card_id.clear()
		NewCardBtn.disabled = false
		EditFamilyRaceBtn.disabled = false
		if mod_selected.card.Card_Array.size() == 0:
			CardItemList.add_item("- No Card -")
			CardItemList.set_item_disabled(0, true)
		else:
			var index = 1
			for card in mod_selected.card.Card_Array:
				var item_name = "%03d : %s (%s)" % [index, card.cardId, card.cardName]
				CardItemList.add_item(item_name)
				all_card_id.append(card.cardId)
				index += 1
		RefreshDeleteBtn()
		Return_card_selected_id_before_action()

func RefreshCardEditControl():
	if mod_selected == null:
		TabCardEdit.hide()
		SaveBtn.disabled = true
		SaveAndCloseBtn.disabled = true
		CloseBtn.disabled = false

func _on_ModOptionButton_item_selected(index):
	if index == 0:
		return
	mod_selected = Mods.GetModData( Mods.all_mod_id[index-1] )
	RefreshCardListControl()
	RefreshCardEditControl()

#-----------------------------------------------
# NewCard
func _on_NewCardBtn_pressed():
	Save_card_selected_id_temp()
	NewCardIdEdit.text = ""
	NewCardConfirmBtn.disabled = true
	NewCardControl.show()
	NewCardIdEdit.grab_focus()
	
func _on_NewCardCancelBtn_pressed():
	NewCardControl.hide()

func _on_NewCardIdEdit_text_changed(new_text):
	var save_disable = false
	if new_text.empty() or ( " " in new_text ) or all_card_id.has(new_text):
		save_disable = true
	NewCardConfirmBtn.disabled = save_disable

func _on_NewCardConfirmBtn_pressed():
	var new_card_id = NewCardIdEdit.text
	var new_card = CardData.new( new_card_id )
	new_card.cardRealId = new_card_id
	mod_selected.card.Card_Array.append( new_card )
	NewCardControl.hide()
	RefreshCardListControl()
	all_card_id.append(new_card_id)

func _on_NewCardIdEdit_text_entered(new_text):
	if new_text.empty() or ( " " in new_text ) or all_card_id.has(new_text):
		return
	_on_NewCardConfirmBtn_pressed()

#-----------------------------------------------
# Edit Family Race
func _on_EditFamilyRaceBtn_pressed():
	EditFamilyRace_Control.show()
	EditFamily.set_mod_data(mod_selected.card.Family.duplicate())
	EditRace.set_mod_data(mod_selected.card.Race.duplicate())

func _on_CloseBtn_pressed():
	EditFamilyRace_Control.hide()

func _on_SaveBtn_pressed():
	var new_family = EditFamily.get_familyrace_arrary()
	mod_selected.card.Family = new_family
	var new_race = EditRace.get_familyrace_arrary()
	mod_selected.card.Race = new_race
	# Save Mod
	Mods.SaveModData(mod_selected)
	if TabCardEdit.visible:
		TabCardEdit.set_mod_familyrace(mod_selected.card)

func _on_SaveAndCloseBtn_pressed():
	_on_SaveBtn_pressed()
	_on_CloseBtn_pressed()
#-----------------------------------------------

func _on_CardItemList_item_selected(index):
	TabCardEdit.show()
	TabCardEdit.set_mod_familyrace(mod_selected.card)
	card_selected_index = index
	card_selected = mod_selected.card.Card_Array[card_selected_index]
	TabCardEdit.set_card_data( card_selected )
	TabCardEdit.current_tab = 0
	RefreshSaveCardBtn()
	RefreshDeleteBtn()
	Save_card_selected_id_temp()

func RefreshSaveCardBtn():
	if card_selected != null:
		SaveBtn.disabled = false
		SaveAndCloseBtn.disabled = false
	else:
		SaveBtn.disabled = true
		SaveAndCloseBtn.disabled = true

func _on_SaveCardBtn_pressed():
	card_selected = TabCardEdit.get_card_data()
	mod_selected.card.Card_Array[ card_selected_index ] = card_selected
	Mods.SaveModData(mod_selected)
	RefreshCardListControl()

func _on_CloseCardBtn_pressed():
	get_tree().get_root().find_node("Lobby", true, false).show()
	queue_free()

func _on_SaveAndCloseCardBtn_pressed():
	_on_SaveCardBtn_pressed()
	_on_CloseCardBtn_pressed()

#----------------------------------
# Delete Card & Delete Multiple
func RefreshDeleteBtn():
	DeleteMultiBtn.disabled = not mod_selected.card.Card_Array.size() > 1
	if card_selected != null:
		DeleteCardBtn.disabled = false
	else:
		DeleteCardBtn.disabled = true

func _on_DeleteCardBtn_pressed():
	Remove_card_from_mod(card_selected_index)
	card_selected = null
	card_selected_index = 0
	TabCardEdit.hide()
	RefreshSaveCardBtn()
	RefreshCardListControl()

func Remove_card_from_mod(removed_id):
	all_card_id.remove(removed_id)
	mod_selected.card.Card_Array.remove(removed_id)

func _on_DeleteMultiBtn_pressed():
	Save_card_selected_id_temp()
	deleting_multi = true
	TabCardEdit.hide()
	NewCardBtn.disabled = true
	EditFamilyRaceBtn.disabled = true
	DeleteCardBtn.disabled = true
	DeleteMultiBtn.disabled = true
	ModOptionBtn.disabled = true
	SaveAndCloseBtn.disabled = true
	SaveBtn.disabled = true
	CloseBtn.disabled = true
	DelConfirm.show()
	DelCanCel.show()
	CardItemList.unselect_all()
	CardItemList.select_mode = ItemList.SELECT_MULTI

func _on_DelCancelBtn_pressed():
	deleting_multi = false
	#---------------------------------
	CardItemList.unselect_all()
	CardItemList.select_mode = ItemList.SELECT_SINGLE
	if card_selected != null:
		CardItemList.select(card_selected_index)
		TabCardEdit.show()
	else:
		TabCardEdit.hide()
	RefreshSaveCardBtn()
	CloseBtn.disabled = false
	NewCardBtn.disabled = false
	EditFamilyRaceBtn.disabled = false
	DeleteCardBtn.disabled = false
	DeleteMultiBtn.disabled = false
	ModOptionBtn.disabled = false
	DelConfirm.hide()
	DelCanCel.hide()

func _on_DelConfirmBtn_pressed():
	deleting_multi = false
	var arrary_card_delete = CardItemList.get_selected_items()
	arrary_card_delete.invert()
	for i in arrary_card_delete:
		Remove_card_from_mod(i)
	#---------------------------------
	CardItemList.unselect_all()
	CardItemList.select_mode = ItemList.SELECT_SINGLE
	RefreshCardListControl()
	RefreshSaveCardBtn()
	CloseBtn.disabled = false
	NewCardBtn.disabled = false
	EditFamilyRaceBtn.disabled = false
	DeleteCardBtn.disabled = false
	DeleteMultiBtn.disabled = false
	ModOptionBtn.disabled = false
	DelConfirm.hide()
	DelCanCel.hide()

#---------------------------------------------
# Remember CardItemList Index
func Save_card_selected_id_temp():
	if card_selected != null:
		card_selected_id_temp = card_selected.cardId
	else:
		card_selected_id_temp = ""

func Return_card_selected_id_before_action():
	if card_selected_id_temp == "":
		return
	var check_exist = all_card_id.find(card_selected_id_temp)
	if check_exist >= 0:
		CardItemList.select(check_exist)
		TabCardEdit.show()
	else:
		CardItemList.unselect_all()
		TabCardEdit.hide()
#----

