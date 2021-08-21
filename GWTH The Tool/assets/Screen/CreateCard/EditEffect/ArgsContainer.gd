extends VBoxContainer
class_name ArgsContainer

onready var AddArgsBtn : Button = $AddArgsBtn

onready var ArgsBox = preload("res://assets/Screen/CreateCard/EditEffect/ArgsBox.tscn")

var all_args = []
var all_args_container = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if temp != all_args:
#		temp = all_args.duplicate()
#		print_debug(temp)

func get_all_args() -> Array:
	return all_args
func set_all_args(card_all_args):
	all_args = card_all_args
	var index_args = 0
	for args in all_args:
		add_args(index_args, args)
		index_args += 1

func _on_AddArgsBtn_pressed():
	var new_id = all_args.size()
	add_args(new_id, "")

func add_args(args_id :int, args_text :String = ""):
	var new_args = ArgsBox.instance()
	new_args.init(args_id, args_text)
	add_child(new_args)
	move_child(new_args, args_id)
	new_args.connect("remove_args", self, "remove_args_method")
	new_args.connect("change_args", self, "change_args_method")
	all_args.append(args_text)
	all_args_container.append(new_args)

func remove_args_method(removed_args):
	all_args.remove(removed_args.id)
	remove_child(removed_args)
	all_args_container.erase(removed_args)
	removed_args.queue_free()
	rearrange_args()

func change_args_method(index, new_text):
	all_args[index] = new_text

func rearrange_args():
	var id = 0
	for child in all_args_container:
		child.rearrange_id(id)
		id += 1
