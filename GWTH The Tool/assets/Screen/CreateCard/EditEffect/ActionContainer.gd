extends VBoxContainer
class_name ActContainer

onready var ActBox = preload("res://assets/Screen/CreateCard/EditEffect/ActionBox.tscn")

var all_act_node :Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_all_act_data() -> Array:
	var all_act_data = []
	for child in all_act_node:
		all_act_data.append( child.get_act_data() )
	return all_act_data

func set_all_act_data( array_act:Array ):
	var act_id = 0
	for act in array_act:
		add_act_node(act_id, act)
		act_id += 1

func _on_AddActionBtn_pressed():
	var new_id = all_act_node.size()
	add_act_node(new_id)

func add_act_node(new_id :int = 0, card_act : EffectData.Action = null ):
	var new_act = ActBox.instance()
	new_act.init(new_id, card_act)
	add_child(new_act)
	move_child(new_act, new_id)
	new_act.connect("remove_act", self, "remove_act_method")
	all_act_node.append(new_act)

func remove_act_method(act_node):
	remove_child(act_node)
	all_act_node.erase(act_node)
	act_node.queue_free()
	rearrange_args()

func rearrange_args():
	var id = 0
	for child in all_act_node:
		child.rearrange_id(id)
		id += 1
