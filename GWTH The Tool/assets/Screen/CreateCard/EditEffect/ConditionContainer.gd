extends VBoxContainer
class_name AllConditionContainer

onready var CondBox = preload("res://assets/Screen/CreateCard/EditEffect/ConditionBox.tscn")

var all_cond_node :Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_all_cond_data() -> Array:
	var all_cond_data = []
	for child in all_cond_node:
		all_cond_data.append( child.get_condition_data() )
	return all_cond_data

func set_all_cond_data( array_cond:Array ):
	var cond_id = 0
	for cond in array_cond:
		add_cond_node(cond_id, cond)
		cond_id += 1

func _on_AddCondBtn_pressed():
	var new_id = all_cond_node.size()
	add_cond_node(new_id)

func add_cond_node(new_id :int = 0, card_cond : EffectData.Cond = null ):
	var new_cond = CondBox.instance()
	new_cond.init(new_id, card_cond)
	add_child(new_cond)
	move_child(new_cond, new_id)
	new_cond.connect("remove_cond", self, "remove_cond_method")
	all_cond_node.append(new_cond)

func remove_cond_method(cond_node):
	remove_child(cond_node)
	all_cond_node.erase(cond_node)
	cond_node.queue_free()
	rearrange_args()

func rearrange_args():
	var id = 0
	for child in all_cond_node:
		child.rearrange_id(id)
		id += 1
