extends Control

onready var decklistMenu : MenuButton = $"TabContainer/Deck Manager/DeckListMenu"
onready var saveBtn : Button = $"TabContainer/Deck Manager/SaveBtn"
onready var saveAsBtn : Button = $"TabContainer/Deck Manager/SaveAsBtn"
onready var deleteBtn : Button = $"TabContainer/Deck Manager/DeleteBtn"
onready var deckNameLineEdit : LineEdit = $"TabContainer/Deck Manager/DeckNameLineEdit"

onready var cardDeckNumLabel : Label = $"TabContainer/Deck Manager/CardDeckNumLabel"
onready var sortBtn : Button = $"TabContainer/Deck Manager/SortBtn"
onready var shuffleBtn : Button = $"TabContainer/Deck Manager/ShuffleBtn"
onready var clearBtn : Button = $"TabContainer/Deck Manager/ClearBtn"

onready var allCardItemList : VBoxContainer = $AllCardPanel/ScrollContainer/AllCardContainer
onready var allCardBtn : Button = preload("res://assets/Screen/Deck/AllCardBtn.tscn").instance()

onready var cardInDeckContainer : GridContainer = $DeckPanel/ScrollContainer/CardInDeckGridContainer
onready var cardInDeckBtn : Button = preload("res://assets/Screen/Deck/CardInDeckBtn.tscn").instance()

var mouse_hover = false

var path_deck_save = "user://Deck"
var deckfile_extension = ".deck"
var list_deck_save = []
var deck_list = []

var deck_loaded : String = ""

var card_num_hollow : int = 0
var card_num_magic : int = 0
var card_num_area : int = 0

func _ready():
	preload_decklist()
	refresh_all_card()

func preload_decklist():
	var save_decklist = File.new()
	if not save_decklist.file_exists(path_deck_save):
		# Error! We don't have a save to load.
		create_decklist_folder()
	load_decklist_files()

func create_decklist_folder():
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("Deck")
	
func load_decklist_files():
	var files = list_deck_in_directory(path_deck_save)
	list_deck_save.clear()
	decklistMenu.get_popup().clear()
	if files != []:
		for item in files:
			var deckName = item.replace(deckfile_extension, "")
			list_deck_save.append(deckName)
			decklistMenu.get_popup().add_item(deckName)
		
	if deck_loaded == "":
		# No ANY Deck
		deck_list = []
		#deck_loaded = ""
		deck_panel_clear()
		refresh_cardDeckNumLabel()
		refresh_deckListMenu()
	
	if decklistMenu.get_popup().has_signal("id_pressed"):
		decklistMenu.get_popup().disconnect("id_pressed", self, "_on_DeckListMenu_pressed")
	decklistMenu.get_popup().connect("id_pressed", self, "_on_DeckListMenu_pressed")

func _on_DeckListMenu_pressed(ID):
	#print(decklistMenu.get_popup().get_item_text(ID), " pressed")
	load_deck_file( decklistMenu.get_popup().get_item_text(ID) )
	deckNameLineEdit.text = ""

func load_deck_file(deckName):
	deck_list.clear()
	var deckfile = File.new()
	var path_deckfile = "%s/%s" % [path_deck_save, deckName + deckfile_extension]
	if not deckfile.file_exists(path_deckfile):
		# Error! We don't have a save to load.
		return
	deckfile.open(path_deckfile, File.READ)
	
	var deck_file_data = parse_json(deckfile.get_line())
	for card_id in deck_file_data:
		deck_list.append( CardData.new(card_id) )
	deck_loaded = deckName
	
	deckfile.close()
	#---
	card_num_hollow = 0
	card_num_magic = 0
	card_num_area = 0
	for card in deck_list:
		match(card.cardType):
			EnumData.CardType.HOLLOW:
				card_num_hollow += 1
			EnumData.CardType.MAGIC:
				card_num_magic += 1
			EnumData.CardType.AREA:
				card_num_area += 1
	# --> deck_list
	deck_panel_clear()
	refresh_cardDeckNumLabel()
	refresh_deckListMenu()
	create_card_in_deck_container()
	decklistMenu.text = deckName
	saveAsBtn.disabled = true

func list_deck_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		print_debug(file)
		if file == "":
			break
		#elif not file.begins_with("."):
		elif not file.begins_with(".") && not file.ends_with(".import"):
			files.append(file)
	dir.list_dir_end()
	
	return files

func refresh_all_card():
	#-----
	# Remove All Child
	for child in allCardItemList.get_children():
		allCardItemList.remove_child(child)
		child.queue_free()
	#-----
	for card in CardDatabase.card.values():
		var textture = CardDatabase.texture[card.cardId]
		var new_ACard = allCardBtn.duplicate()
		allCardItemList.add_child(new_ACard)
		new_ACard.set_cardPic(textture)
		new_ACard.set_cardData(card)
		new_ACard.refresh_richText()

func deck_panel_clear():
	# Remove All Child
	for child in cardInDeckContainer.get_children():
		cardInDeckContainer.remove_child(child)
		child.queue_free()

func create_card_in_deck_container():
	for card in deck_list:
		var textture = CardDatabase.get_texture(card.cardId)
		var new_cardInDeck = cardInDeckBtn.duplicate()
		cardInDeckContainer.add_child(new_cardInDeck)
		new_cardInDeck.set_cardPic(textture)
		new_cardInDeck.set_cardData(card)


func AddCardToDeckList(card, index):
	print_debug("deck size : %s" % deck_list.size())
	if deck_list.size() == 0:
		deck_list.append(card)
	else:
		deck_list.insert(index, card)
	print_debug(index)
	print_debug(deck_list)
	match(card.get_cardType()):
		EnumData.CardType.HOLLOW:
			card_num_hollow += 1
		EnumData.CardType.MAGIC:
			card_num_magic += 1
		EnumData.CardType.AREA:
			card_num_area += 1
	refresh_cardDeckNumLabel()

func RemoveAddFromDeckList(index):
	match(deck_list[index].get_cardType()):
		EnumData.CardType.HOLLOW:
			card_num_hollow -= 1
		EnumData.CardType.MAGIC:
			card_num_magic -= 1
		EnumData.CardType.AREA:
			card_num_area -= 1
	deck_list.remove(index)
	refresh_cardDeckNumLabel()

func refresh_deckListMenu():
	if deck_loaded == "":
		# no deck loaded
		saveBtn.disabled = true
		deleteBtn.disabled = true
		saveAsBtn.disabled = true
	else:
		saveBtn.disabled = false
		deleteBtn.disabled = false

func refresh_cardDeckNumLabel():
	var deck_num_label = "Card Num: %s/40\nH: %s M: %s A: %s"
	var decknum = deck_list.size()
	deck_num_label = deck_num_label % [decknum, card_num_hollow, card_num_magic, card_num_area]
	cardDeckNumLabel.text = deck_num_label
	var btn_disable = ( deck_list.size() == 0 )
	sortBtn.disabled = btn_disable
	shuffleBtn.disabled = btn_disable
	clearBtn.disabled = btn_disable

func _on_SortBtn_pressed():
	deck_panel_clear()
	#-----
	deck_list.sort_custom(self, "sort_card_by_type")
	var hollow_d : Array = deck_list.slice(0, card_num_hollow)
	var magic_d : Array = deck_list.slice(card_num_hollow, card_num_hollow+card_num_magic)
	var area_d : Array = deck_list.slice(card_num_hollow+card_num_magic, deck_list.size())
	hollow_d.sort_custom(self, "sort_card_by_id")
	magic_d.sort_custom(self, "sort_card_by_id")
	area_d.sort_custom(self, "sort_card_by_id")
	deck_list.clear()
	deck_list.append_array(hollow_d)
	deck_list.append_array(magic_d)
	deck_list.append_array(area_d)
	#-----
	create_card_in_deck_container()

static func sort_card_by_type(a, b):
	if a["cardType"] < b["cardType"]:
		return true
	return false

static func sort_card_by_id(a, b):
	if a["cardId"] < b["cardId"]:
		return true
	return false

func _on_ShuffleBtn_pressed():
	deck_panel_clear()
	#-----
	deck_list.shuffle()
	#-----
	create_card_in_deck_container()

func _on_ClearBtn_pressed():
	deck_panel_clear()
	deck_list.clear()
	card_num_hollow = 0
	card_num_magic = 0
	card_num_area = 0
	refresh_cardDeckNumLabel()

func _on_DeckNameLineEdit_text_changed(new_text):
	if new_text != "":
		saveAsBtn.disabled = false
	else:
		saveAsBtn.disabled = true

func _on_SaveAsBtn_pressed():
	var deckName = deckNameLineEdit.text
	var deckfile = File.new()
	var path_deckfile = "%s/%s" % [path_deck_save, deckName + deckfile_extension]
	deckfile.open(path_deckfile, File.WRITE)
	var deck_data = []
	for card in deck_list:
		deck_data.append(card.cardId)
	deckfile.store_line(to_json(deck_data))
	deckfile.close()
	deck_loaded = deckName
	refresh_deckListMenu()
	load_decklist_files()
	decklistMenu.text = deckName

func _on_SaveBtn_pressed():
	var deckfile = File.new()
	var path_deckfile = "%s/%s" % [path_deck_save, deck_loaded + deckfile_extension]
	deckfile.open(path_deckfile, File.WRITE)
	var deck_data = []
	for card in deck_list:
		deck_data.append(card.cardId)
	deckfile.store_line(to_json(deck_data))
	deckfile.close()

func _on_DeleteBtn_pressed():
	var dir = Directory.new()
	var path_deckfile = "%s/%s" % [path_deck_save, deck_loaded + deckfile_extension]
	dir.remove(path_deckfile)
	deck_loaded = ""
	card_num_hollow = 0
	card_num_magic = 0
	card_num_area = 0
	_on_ClearBtn_pressed()
	refresh_deckListMenu()
	load_decklist_files()
	decklistMenu.text = "<Load Deck File>"
	
