extends Control
class_name ModClass

onready var ModsPanel : Panel = $ModsPanel

onready var ModsItemList : ItemList = $ModsPanel/ModsItemList
onready var ModNameLabel : Label = $ModsPanel/ModNameLabel
onready var ModHelpLabel : RichTextLabel = $ModsPanel/RichTextLabel
onready var EnableBtn : Button = $ModsPanel/EnableBtn
onready var DisableBtn : Button = $ModsPanel/DisableBtn
onready var EditInfoBtn : Button = $ModsPanel/EditInfoBtn

onready var ModInfoControl : Control = $ModInfo
onready var ModInfoPanel : Panel = $ModInfo/ModInfoPanel
onready var ModIdEdit : LineEdit = $ModInfo/ModInfoPanel/ModIdLineEdit
onready var ModNameEdit : LineEdit = $ModInfo/ModInfoPanel/ModNameLineEdit
onready var AuthorEdit : LineEdit = $ModInfo/ModInfoPanel/AuthorLineEdit
onready var VersionEdit : LineEdit = $ModInfo/ModInfoPanel/VersionLineEdit
onready var TypeOption : OptionButton = $ModInfo/ModInfoPanel/TypeOptionButton
onready var DescEdit : TextEdit = $ModInfo/ModInfoPanel/DescTextEdit
onready var SaveModInfoBtn : Button = $ModInfo/ModInfoPanel/SaveButton
onready var CancelModInfoBtn : Button = $ModInfo/ModInfoPanel/CancelButton

onready var FilterOption : OptionButton = $ModsPanel/FilterOptionButton
onready var SortByOption : OptionButton = $ModsPanel/SortByOptionButton
onready var SearchEdit : LineEdit = $ModsPanel/SearchLineEdit

class ModInfo:
	var Id : String
	var Name : String
	var Author : String
	var Version : String
	enum Type {
		Card_Only,
		Stroy_Mode,
		Card_And_Story
	}
	var TypeState : int
	var Description : String
	var LastDateEdit

class ModCard:
	var Family : Array
	var Race : Array
	var Card_Array : Array
	
	func compare_change(another_mod : ModCard) -> bool:
		return (Family == another_mod.Family and Race == another_mod.Race and Card_Array == another_mod.Card_Array)

class ModStory:
	var Id : String
	var Name : String

class Mod extends Node:
	var info : ModInfo = ModInfo.new()
	var card : ModCard = ModCard.new()
	var story : ModStory = ModStory.new()
	var mod_enable : bool
	
	func compare_change(another_mod: Mod) -> bool:
		return card.compare_change(another_mod.card)

class ModCustomSorter:
	# ascending
	static func sort_ascending_id(a, b):
		if a.info.Id < b.info.Id:
			return true
		return false
	
	static func sort_ascending_name(a, b):
		if a.info.Name < b.info.Name:
			return true
		return false
	
	static func sort_ascending_author(a, b):
		if a.info.Author < b.info.Author:
			return true
		return false
	
	static func sort_ascending_type(a, b):
		if a.info.TypeState < b.info.TypeState:
			return true
		return false
	
	static func sort_ascending_version(a, b):
		if a.info.Version < b.info.Version:
			return true
		return false
	
	static func sort_ascending_lastDateEdit(a, b):
		if a.info.LastDateEdit < b.info.LastDateEdit:
			return true
		return false
	
	# descending
	static func sort_descending_id(a, b):
		if a.info.Id > b.info.Id:
			return true
		return false
	
	static func sort_descending_name(a, b):
		if a.info.Name > b.info.Name:
			return true
		return false
	
	static func sort_descending_author(a, b):
		if a.info.Author > b.info.Author:
			return true
		return false
	
	static func sort_descending_type(a, b):
		if a.info.TypeState > b.info.TypeState:
			return true
		return false
	
	static func sort_descending_version(a, b):
		if a.info.Version > b.info.Version:
			return true
		return false
	
	static func sort_descending_lastDateEdit(a, b):
		if a.info.LastDateEdit > b.info.LastDateEdit:
			return true
		return false

var path_modlist_save = "user://modlist.save"

enum MOD_STATE {
	View,
	Add,
	Edit
}
var modInfo_state = MOD_STATE.View

var all_mod = []
var all_mod_id = []
var all_mod_display = []

var mod_in_use = []
var mod_selected : Mod = null

var template_modhelp_text = ""

var filter_selected : int = 0
var sort_by_selected : int = 0
var search_edit : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():	
	mod_in_use = []
	load_modlist_in_game()
	preload_mods()
	hide_help_ui()
	hide_modinfo_ui()
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func load_modlist_in_game():
	var save_modlist = File.new()
	if not save_modlist.file_exists(path_modlist_save):
		# Error! We don't have a save to load.
		save_modlist_in_game()
	
	save_modlist.open(path_modlist_save, File.READ)
	mod_in_use = str2var(save_modlist.get_as_text())
	save_modlist.close()
	
	for mod in mod_in_use:
		mod_selected = GetModData(mod)
		load_mod(mod_selected)

func save_modlist_in_game():
	var save_modlist = File.new()
	save_modlist.open(path_modlist_save, File.WRITE)
	save_modlist.store_string(var2str(mod_in_use))
	save_modlist.close()

func preload_mods():
	var path
	if OS.is_debug_build():
		path = "res://mods"
	else:
		path = "./mods"
	var files = list_files_in_directory(path)
	all_mod_id = files
	all_mod.clear()
	for item in files:
		var mod = GetModData(item)
		all_mod.append(mod)
	DrawItemInModList()

func hide_help_ui():
	EnableBtn.hide()
	DisableBtn.hide()
	ModNameLabel.hide()
	ModHelpLabel.hide()
	EditInfoBtn.hide()
	ModsItemList.unselect_all()
	mod_selected = null

func hide_modinfo_ui():
	ModInfoControl.hide()

func show_modinfo_ui(modInfo : Mod = null):
	ModIdEdit.editable = true
	if modInfo != null:
		ModIdEdit.text = modInfo.info.Id
		ModIdEdit.editable = false
		ModNameEdit.text = modInfo.info.Name
		AuthorEdit.text = modInfo.info.Author
		VersionEdit.text = modInfo.info.Version
		TypeOption.selected = modInfo.info.TypeState
		DescEdit.text = modInfo.info.Description
		SaveModInfoBtn.disabled = false
	else:
		ModIdEdit.text = ""
		ModNameEdit.text = ""
		AuthorEdit.text = ""
		VersionEdit.text = "1.0.0"
		TypeOption.selected = 0
		DescEdit.text = ""
		SaveModInfoBtn.disabled = true
	ModInfoControl.show()

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		#elif not file.begins_with("."):
		elif not file.begins_with(".") && not file.ends_with(".import"):
			files.append(file)
	dir.list_dir_end()
	
	return files

func GetModData(modName) -> Mod:
	var path = "./mods/%s/mod.info" % modName
	var file := File.new()
	file.open(path, File.READ)
	var data: Dictionary = str2var(file.get_as_text())
	file.close()
	#--------------------
	var mod = Mod.new()
	mod.info.Id = data["info"]["Id"]
	mod.info.Name = data["info"]["Name"]
	mod.info.Author = data["info"]["Author"]
	mod.info.Version = data["info"]["Version"]
	mod.info.TypeState = data["info"]["TypeState"]
	mod.info.Description = data["info"]["Description"]
	mod.info.LastDateEdit = data["info"]["LastDateEdit"]
	
	mod.card.Family = data["card"]["Family"]
	mod.card.Race = data["card"]["Race"]
	mod.card.Card_Array = data["card"]["Card_Array"]
	
	mod.story.Id = data["story"]["Id"]
	mod.story.Name = data["story"]["Name"]
	
	mod.mod_enable = data["mod_enable"]

	return mod

func DrawItemInModList():
	ModsItemList.clear()
	#------------------------
	all_mod_display = []
	if not search_edit.empty():
		for mod in all_mod:
			var se = search_edit
			if se in mod.info.Id or se in mod.info.Name or se in mod.info.Author or se in mod.info.Version or se in mod.info.Description:
				all_mod_display.append(mod)
	else:
		all_mod_display = all_mod
	#------------------------
	match sort_by_selected:
		0: # Id (A-Z)
			all_mod_display.sort_custom(ModCustomSorter, "sort_ascending_id")
		1: # Name (A-Z)
			all_mod_display.sort_custom(ModCustomSorter, "sort_ascending_name")
		2: # Author (A-Z)
			all_mod_display.sort_custom(ModCustomSorter, "sort_ascending_author")
		3: # Type (A-Z)
			all_mod_display.sort_custom(ModCustomSorter, "sort_ascending_type")
		4: # Version (A-Z)
			all_mod_display.sort_custom(ModCustomSorter, "sort_ascending_version")
		5: # Last Date Edit (A-Z)
			all_mod_display.sort_custom(ModCustomSorter, "sort_ascending_lastDateEdit")
		6: # Id (A-Z)
			all_mod_display.sort_custom(ModCustomSorter, "sort_descending_id")
		7: # Name (Z-A)
			all_mod_display.sort_custom(ModCustomSorter, "sort_descending_name")
		8: # Author (Z-A)
			all_mod_display.sort_custom(ModCustomSorter, "sort_descending_author")
		9: # Type (Z-A)
			all_mod_display.sort_custom(ModCustomSorter, "sort_descending_type")
		10: # Version (Z-A)
			all_mod_display.sort_custom(ModCustomSorter, "sort_descending_version")
		11: # Last Date Edit (Z-A)
			all_mod_display.sort_custom(ModCustomSorter, "sort_descending_lastDateEdit")
	#------------------------
	var count = 0
	for mod in all_mod_display:
		#---------
		var skip_mod = false
		match filter_selected:
			0: # All
				pass
			1: # Enable
				if not mod.mod_enable:
					skip_mod = true
			2: # Disable
				if mod.mod_enable:
					skip_mod = false
		if skip_mod:
			continue
		#---------
		ModsItemList.add_item( mod.info.Id )
		ModsItemList.add_item( mod.info.Author )
		ModsItemList.add_item( mod.info.Version )
		ModsItemList.set_item_metadata(count, mod )
		if mod_in_use.has( mod.info.Id ):
			ModsItemList.set_item_custom_bg_color(count, Color.darkgreen)
			ModsItemList.set_item_custom_bg_color(count+1, Color.darkgreen)
			ModsItemList.set_item_custom_bg_color(count+2, Color.darkgreen)
		count += 3

func _on_ModsItemList_multi_selected(index, selected):
	var index_real = index/3
	#print_debug( ModsItemList.get_item_metadata(index_real) )
	var matadata = ModsItemList.get_item_metadata(index_real)
	ModsItemList.unselect_all()
	ModsItemList.select(index_real, false)
	ModsItemList.select(index_real+1, false)
	ModsItemList.select(index_real+2, false)
	refresh_mod_help(matadata)
	if mod_in_use.has( matadata.info.Id ):
		EnableBtn.hide()
		DisableBtn.show()
	else:
		EnableBtn.show()
		DisableBtn.hide()
	ModNameLabel.show()
	ModHelpLabel.show()
	EditInfoBtn.show()
	mod_selected = matadata

func refresh_mod_help(matadata : Mod):
	ModNameLabel.text = matadata.info.Name
	var type_mod = ""
	match matadata.info.TypeState:
		ModInfo.Type.Card_Only: 
			type_mod = "Card Only"
		ModInfo.Type.Stroy_Mode:
			type_mod = "Stroy Mode"
		ModInfo.Type.Card_And_Story:
			type_mod = "Card & Story"
	var help_text = [type_mod, matadata.info.Author, matadata.info.Version, matadata.info.LastDateEdit, matadata.info.Description ]
	if template_modhelp_text.empty():
		template_modhelp_text = ModHelpLabel.text
	ModHelpLabel.text = template_modhelp_text % help_text

func load_pic(index):
	var mod = ModsItemList.get_item_text(index)
	#print_debug(mod)
	#print_debug( list_files_in_directory("./mods//" + mod + "//pics") )
	#print_debug( list_files_in_directory("./mods//" + mod + "//cards") )
	#var card_path = "res://mods/" + mod + "/pics/" + list_files_in_directory("res://mods/" + mod + "/pics")[0]
	#var card_path = "Mods/" + mod + "/pics/" + list_files_in_directory("res://mods/" + mod + "/pics")[0]
	#print_debug( load("user://" + card_path) )
	
	#print_debug( load("user://Mods/std-cards-set-01/pics/st-00001.png") )
	
	var path = "./mods/std-cards-set-01/pics/st-00001.png"
	var file = File.new()
	var image = Image.new()
	file.open(path, File.READ)
	var buffer = file.get_buffer(file.get_len())
	match path.get_extension():
		"png":
			image.load_png_from_buffer(buffer)
		"jpg":
			image.load_jpg_from_buffer(buffer)
	file.close()
	image.lock()
	#print_debug(image)
	
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	#$ModsPanel/TextureRect.texture = texture

func load_card_from_mod(modId, cardId) -> CardData :
	var path = "./mods/%s/cards/%s" % [modId, cardId]
	var file = File.new()
	file.open(path, File.READ)
	var card_json = parse_json( file.get_as_text() )
	file.close()
	var new_card = CardData.new()
	for key in card_json.keys():
		if key == "cardEffectText" || key == "cardRace":
			continue
		new_card.set(key, card_json[key])
	new_card.cardAlternative = card_json["cardAlternative"]
	return new_card

func load_texture_from_mod(modId, textureName) -> Texture : 
	var path = "./mods/%s/pics/%s" % [modId, textureName]
	var file = File.new()
	var image = Image.new()
	file.open(path, File.READ)
	var buffer = file.get_buffer(file.get_len())
	match path.get_extension():
		"png":
			image.load_png_from_buffer(buffer)
		"jpg":
			image.load_jpg_from_buffer(buffer)
	file.close()
	image.lock()
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	#$ModsPanel/TextureRect.texture = texture
	return texture

func _on_EnableBtn_pressed():
	load_mod(mod_selected)
	mod_in_use.append(mod_selected.info.Id)
	save_modlist_in_game()
	EnableBtn.hide()
	DisableBtn.show()
	refresh_ModItemList()

func load_mod(mod):
	return
	# import card
	var mod_card = list_files_in_directory("./mods//" + mod["Id"] + "//cards")
	for card in mod_card:
		var new_card = load_card_from_mod(mod["Id"], card)
		CardDatabase.add_card( new_card.cardId, new_card )
	# import pic
	var mod_pic = list_files_in_directory("./mods//" + mod["Id"] + "//pics")
	
	# import texture
	for pic in mod_pic:
		var texture = load_texture_from_mod(mod["Id"], pic)
		var regex = RegEx.new()
		regex.compile("[.]\\w+")
		var result = regex.search( pic.get_file() )
		if result:
			#print(result.get_string()) # Would print n-0123
			var id_card = pic.get_file().replace( result.get_string() , "")
			CardDatabase.add_texture( id_card, texture)


func _on_DisableBtn_pressed():
	unload_mod(mod_selected)
	mod_in_use.erase(mod_selected.info.Id)
	save_modlist_in_game()
	EnableBtn.show()
	DisableBtn.hide()
	refresh_ModItemList()

func unload_mod(mod):
	return
	# un import card
	var mod_card = list_files_in_directory("./mods//" + mod["Id"] + "//cards")
	for card in mod_card:
		var remove_cardId = card.replace(".json", "")
		CardDatabase.remove_card(remove_cardId)
	# un import pic
	var mod_pic = list_files_in_directory("./mods//" + mod["Id"] + "//pics")
	
	# un import texture
	for pic in mod_pic:
		var texture = load_texture_from_mod(mod["Id"], pic)
		var regex = RegEx.new()
		regex.compile("[.]\\w+")
		var result = regex.search( pic.get_file() )
		if result:
			#print(result.get_string()) # Would print n-0123
			var id_card = pic.get_file().replace( result.get_string() , "")
			CardDatabase.remove_texture(id_card)

func refresh_ModItemList():
	preload_mods()

func _on_RefreshBtn_pressed():
	refresh_ModItemList()

func _on_ExitBtn_pressed():
	get_tree().get_root().find_node("Lobby", true, false).show()
	hide()

func _on_NewModBtn_pressed():
	modInfo_state = MOD_STATE.Add
	show_modinfo_ui()

func create_new_mod():
	var new_mod = Mod.new()
	new_mod.info.Id = ModIdEdit.text
	new_mod.info.Name = ModNameEdit.text
	new_mod.info.Author = AuthorEdit.text
	new_mod.info.Version = VersionEdit.text
	new_mod.info.TypeState = new_mod.info.Type.keys()[TypeOption.selected]
	new_mod.info.Description = DescEdit.text
	new_mod.mod_enable = false
	#---------
	var path
	if OS.is_debug_build():
		path = "res://mods"
	else:
		path = "./mods"
	var dir = Directory.new()
	dir.open(path)
	dir.make_dir(new_mod.info.Id)
	var mod_path = path + "/" +new_mod.info.Id
	dir.open(mod_path)
	dir.make_dir("pics")
	#---------
	SaveModData(new_mod)

func SaveModData(new_mod : Mod):
	var path
	if OS.is_debug_build():
		path = "res://mods"
	else:
		path = "./mods"
	var mod_path = path + "/" + new_mod.info.Id
	#---------
	var time = OS.get_datetime()
	new_mod.info.LastDateEdit = "%d-%02d-%02d %02d:%02d:%02d" % [time["year"], time["month"], time["day"], time["hour"], time["minute"], time["second"]]
	#---------
	var save_data := {}
	save_data["info"] = {
		"Id" : new_mod.info.Id,
		"Name" : new_mod.info.Name,
		"Author" : new_mod.info.Author,
		"Version" : new_mod.info.Version,
		"TypeState" : new_mod.info.TypeState,
		"Description" : new_mod.info.Description,
		"LastDateEdit" : new_mod.info.LastDateEdit,
	}
	save_data["card"] = {
		"Family" : new_mod.card.Family,
		"Race" : new_mod.card.Race,
		"Card_Array" : new_mod.card.Card_Array
	}
	save_data["story"] = {
		"Id" : new_mod.story.Id,
		"Name" : new_mod.story.Name,
	}
	save_data["mod_enable"] = new_mod.mod_enable
	var data_as_string := var2str(save_data)
	var save_mod := File.new()
	save_mod.open(mod_path + "/mod.info", File.WRITE)
	save_mod.store_string(data_as_string)
	save_mod.close()
	#---------
	match modInfo_state:
		MOD_STATE.Add:
			preload_mods()
		MOD_STATE.Edit:
			refresh_mod_help(mod_selected)
	#---------
	hide_modinfo_ui()
	modInfo_state = MOD_STATE.View

func save_new_modinfo():
	mod_selected.info.Name = ModNameEdit.text
	mod_selected.info.Author = AuthorEdit.text
	mod_selected.info.Version = VersionEdit.text
	mod_selected.info.TypeState = TypeOption.selected
	mod_selected.info.Description = DescEdit.text
	#---------
	SaveModData(mod_selected)

func _on_CancelButton_pressed():
	modInfo_state = MOD_STATE.View
	hide_modinfo_ui()

func _on_ModIdLineEdit_text_changed(new_text):
	var save_disable = false
	if new_text.empty() or ( " " in new_text ) or all_mod_id.has(new_text):
		save_disable = true
	SaveModInfoBtn.disabled = save_disable

func _on_SaveButton_pressed():
	match modInfo_state:
		MOD_STATE.Add:
			create_new_mod()
		MOD_STATE.Edit:
			save_new_modinfo()

func _on_EditInfoBtn_pressed():
	modInfo_state = MOD_STATE.Edit
	show_modinfo_ui(mod_selected)

func _on_FilterOptionButton_item_selected(index):
	if filter_selected != index:
		filter_selected = index
		DrawItemInModList()
		hide_help_ui()

func _on_SortByOptionButton_item_selected(index):
	if sort_by_selected != index:
		sort_by_selected = index
		DrawItemInModList()
		hide_help_ui()

func _on_SearchLineEdit_text_changed(new_text):
	if search_edit != new_text:
		search_edit = new_text
		DrawItemInModList()
		hide_help_ui()

#--------------------------------------------------------------------------

