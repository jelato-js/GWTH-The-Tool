extends Control
class_name FamilyRaceEdit

onready var TextLabel : Label = $Label
onready var EditContainer : VBoxContainer = $ScrollContainer/VBoxContainer

onready var NewEdit : LineEdit = $NewEdit
onready var AddNewBtn : Button = $AddNewBtn

enum TYPE {
	Family,
	Race
}
export(TYPE) var typeState = TYPE.Family

var mod_familyrace_edit = []

onready var FamilyRaceContainer = preload("res://assets/Screen/CreateCard/EditFamilyAndRace/FamilyRaceContainer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if typeState == TYPE.Race:
		TextLabel.text = "Race :"
	AddNewBtn.disabled = true

func set_mod_data(data : Array):
	mod_familyrace_edit = data
	refresh()

func refresh():
	for child in EditContainer.get_children():
		EditContainer.remove_child(child)
		child.queue_free()
	if mod_familyrace_edit.size() > 0:
		for item in mod_familyrace_edit:
			add_familyrace_container(item)

func can_add_this_name(this_name) -> bool:
	return not ( this_name.empty() or ( " " in this_name ) or mod_familyrace_edit.has(this_name) )

func _on_NewEdit_text_changed(new_text):
	var save_disable = false
	if new_text.empty() or ( " " in new_text ) or mod_familyrace_edit.has(new_text):
		save_disable = true
	AddNewBtn.disabled = save_disable

func _on_AddNewBtn_pressed():
	var new_familyrace = NewEdit.text
	add_familyrace_container(new_familyrace)
	mod_familyrace_edit.append(new_familyrace)
	NewEdit.text = ""
	AddNewBtn.disabled = true

func add_familyrace_container(new_text_label):
	var container = FamilyRaceContainer.instance()
	EditContainer.add_child(container)
	container.set_data(typeState, new_text_label)
	container.connect("remove_container", self, "remove_container_method")

func remove_container_method(container : HBoxContainer):
	var text_removed = container.get_label_name()
	mod_familyrace_edit.erase(text_removed)
	container.queue_free()

func get_familyrace_arrary() -> Array:
	return mod_familyrace_edit.duplicate()

func _on_NewEdit_text_entered(new_text):
	if can_add_this_name(new_text):
		_on_AddNewBtn_pressed()
