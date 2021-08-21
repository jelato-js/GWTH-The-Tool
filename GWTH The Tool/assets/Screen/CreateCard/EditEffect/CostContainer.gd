extends VBoxContainer
class_name CostContainer

onready var CostBox = preload("res://assets/Screen/CreateCard/EditEffect/CostBox.tscn")

var all_cost_node :Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_all_cost_data() -> Array:
	var all_cost_data = []
	for child in all_cost_node:
		all_cost_data.append( child.get_cost_data() )
	return all_cost_data

func set_all_cost_data( array_cost:Array ):
	var cost_id = 0
	for cost in array_cost:
		add_cost_node(cost_id, cost)
		cost_id += 1

func _on_AddCostBtn_pressed():
	var new_id = all_cost_node.size()
	add_cost_node(new_id)

func add_cost_node(new_id :int = 0, card_cost : EffectData.Cost = null ):
	var new_cost = CostBox.instance()
	new_cost.init(new_id, card_cost)
	add_child(new_cost)
	move_child(new_cost, new_id)
	new_cost.connect("remove_cost", self, "remove_cost_method")
	all_cost_node.append(new_cost)

func remove_cost_method(cost_node):
	remove_child(cost_node)
	all_cost_node.erase(cost_node)
	cost_node.queue_free()
	rearrange_args()

func rearrange_args():
	var id = 0
	for child in all_cost_node:
		child.rearrange_id(id)
		id += 1
