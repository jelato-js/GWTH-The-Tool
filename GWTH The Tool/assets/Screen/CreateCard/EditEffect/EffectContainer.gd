extends VBoxContainer
class_name EffectContainer

onready var EffectBox = preload("res://assets/Screen/CreateCard/EditEffect/EffectBox.tscn")

var all_effect_node = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_effect_card_data() -> Array:
	var all_effect_card = []
	for effect_node in all_effect_card:
		var effect_card = EffectData.new()
		effect_card.effectLabel = effect_node.get_effect_label()
		effect_card.condition = effect_node.get_all_cond()
		effect_card.cost = effect_node.get_all_cost()
		effect_card.action = effect_node.get_all_act()
		all_effect_card.append(effect_card)
	return all_effect_card

func set_effect_catd_data( all_effect_card :Array):
	var eff_id = 0
	for effect_card in all_effect_card:
		add_effect_node(eff_id, effect_card)
		eff_id += 1

func _on_AddEffectBtn_pressed():
	var new_id = all_effect_node.size()
	add_effect_node(new_id)

func add_effect_node(new_id :int = 0, card_effect :EffectData = null):
	var new_effect = EffectBox.instance()
	new_effect.init(new_id, card_effect)
	add_child(new_effect)
	move_child(new_effect, new_id)
	new_effect.connect("remove_effect", self, "remove_effect_method")
	all_effect_node.append(new_effect)

func remove_effect_method(effect_node :EffectBox):
	remove_child(effect_node)
	all_effect_node.erase(effect_node)
	effect_node.queue_free()
	rearrange_effect_id()

func rearrange_effect_id():
	var id = 0
	for child in all_effect_node:
		child.rearrange_id(id)
		id += 1
