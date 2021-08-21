extends VBoxContainer

onready var cardBtn : Button = preload("res://assets/Screen/Deck/CardInDeckBtn.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func Card_clicked(node):
	var new_card = cardBtn.duplicate()
	#new_card
	get_tree().get_root().add_child(new_card)
	var rect_card_size = new_card.get_rect().size
	var mouse_off = Vector2(rect_card_size.x / 2,rect_card_size.y / 2)
	var new_card_pos = get_global_mouse_position()
	new_card.mouse_off = mouse_off
	new_card.set_global_position( new_card_pos )
	new_card.set_cardPic(node.get_cardPic_texture())
	new_card.set_cardData(node.get_cardData())
	new_card.Selected()
	
	
