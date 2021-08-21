extends Control

onready var TextLabel : Label = $Label
onready var ItemContainer : VBoxContainer = $ScrollContainer/VBoxContainer
onready var RichText : RichTextLabel = $RichTextLabel

enum TYPE {
	Family,
	Race
}
export(TYPE) var typeState = TYPE.Family

var mod_familyrace_checkBox = []
var card_familyrace_checkBox = {}

var card_familyrace_temp : String = ""

var edit_enable = true

onready var FamilyRaceCheckBox = preload("res://assets/Screen/CreateCard/EditCard/FamilyRaceCheckBox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if typeState == TYPE.Race:
		TextLabel.text = "Race :"

func set_mod_familyrace(mod_familyrace : Array):
	mod_familyrace_checkBox = mod_familyrace
	if card_familyrace_temp != null:
		set_card_familyrace(card_familyrace_temp)

func set_card_familyrace(card_familyrace : String):
	var arrary_text : Array = card_familyrace.split(",")
	card_familyrace_checkBox.clear()
	for item in mod_familyrace_checkBox:
		card_familyrace_checkBox[item] = arrary_text.has(item)
	RichText.text = card_familyrace
	card_familyrace_temp = RichText.text
	refresh_container()

func get_card_familyrace() -> String:
	return RichText.text

func refresh_container():
	for child in ItemContainer.get_children():
		ItemContainer.remove_child(child)
		child.queue_free()
	if mod_familyrace_checkBox.size() > 0:
		for item in mod_familyrace_checkBox:
			add_familyrace_checkbox(item)

func add_familyrace_checkbox(new_checkBox):
	var checkBox = FamilyRaceCheckBox.instance()
	ItemContainer.add_child(checkBox)
	checkBox.set_data(typeState, new_checkBox)
	checkBox.connect("toggled_checkbox", self, "toggled_checkbox_method")

func toggled_checkbox_method(checkBox : CheckBox):
	print_debug("%s : %s" % [ checkBox.text, checkBox.pressed ])
	card_familyrace_checkBox[checkBox.text] = checkBox.pressed
	if checkBox.pressed:
		add_text_to_richtext(checkBox.text)
	else:
		remove_text_from_richtext(checkBox.text)

func count_checkbox_pressed() -> int:
	var count = 0
	for item in card_familyrace_checkBox:
		if card_familyrace_checkBox[item] == true:
			count += 1
	return count

func add_text_to_richtext(add_text):
	var count = count_checkbox_pressed()
	if count == 1:
		RichText.text = add_text
	else:
		RichText.text += ", " + add_text

func remove_text_from_richtext(remove_text):
	var count = count_checkbox_pressed()
	if count == 0:
		RichText.text = ""
	else:
		var arrary_text : Array = RichText.text.split(", ")
		arrary_text.erase(remove_text)
		if arrary_text.size() > 0:
			RichText.text = arrary_text.pop_front()
			for add_text in arrary_text:
				RichText.text += ", " + add_text
		else:
			RichText.text = ""

func set_enable(active : bool = true):
	edit_enable = active
	if edit_enable:
		for checkBox in ItemContainer.get_children():
			checkBox.disabled = false
		RichText.set("custom_colors/default_color", Color.white)
	else:
		for checkBox in ItemContainer.get_children():
			checkBox.disabled = true
		RichText.set("custom_colors/default_color", Color.webgray)
