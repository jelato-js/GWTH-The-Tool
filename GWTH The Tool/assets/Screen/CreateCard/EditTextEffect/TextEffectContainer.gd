extends VBoxContainer

onready var TextEffectBox = preload("res://assets/Screen/CreateCard/EditTextEffect/TextEffectBox.tscn")

var all_text_effect_node :Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_all_text_effect_data() -> Array:
	var all_text_effect_data = []
	for child in all_text_effect_node:
		all_text_effect_data.append( child.get_text_effect() )
	return all_text_effect_data

func set_all_text_effect_data( array_text_effect:Array ):
	var text_id = 0
	for text_effect in array_text_effect:
		add_text_effect_node(text_id, text_effect)
		text_id += 1

func _on_AddTextEffectBtn_pressed():
	var id = all_text_effect_node.size()
	add_text_effect_node(id, "")

func add_text_effect_node(new_id :int = 0, text_effect : String = "" ):
	var new_text_effect = TextEffectBox.instance()
	new_text_effect.init(new_id, text_effect)
	add_child(new_text_effect)
	move_child(new_text_effect, new_id)
	new_text_effect.connect("remove_texteffect", self, "remove_texteffect_method")
	all_text_effect_node.append(new_text_effect)

func remove_texteffect_method(text_effect_node):
	remove_child(text_effect_node)
	all_text_effect_node.erase(text_effect_node)
	text_effect_node.queue_free()
	rearrange_args()

func rearrange_args():
	var id = 0
	for child in all_text_effect_node:
		child.rearrange_id(id)
		id += 1
