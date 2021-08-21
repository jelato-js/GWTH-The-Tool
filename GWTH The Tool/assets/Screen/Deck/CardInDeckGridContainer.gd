extends GridContainer

onready var cardBtn : Button = preload("res://assets/Screen/Deck/CardInDeckBtn.tscn").instance()

var deckRoot : Control = null

func _ready():
	deckRoot = get_tree().get_nodes_in_group("DeckRoot")[0]

func Card_clicked(node):
	var old_goble_rect = node.get_global_rect()
	var goble_rect = Rect2(old_goble_rect.position.x, old_goble_rect.position.y, old_goble_rect.size.x, old_goble_rect.size.y)
	var index_node = get_children().find(node)
	remove_child(node)
	get_tree().get_root().add_child(node)
	node.set_global_position( goble_rect.position )
	node.Selected()
	deckRoot.RemoveAddFromDeckList(index_node)

func MoveCardToDeck(node):
	var x_index = int(get_local_mouse_position().x) / 54
	var y_index = int(get_local_mouse_position().y) / 73
	var index_inserted = (y_index * 8) + x_index
	if index_inserted > get_child_count():
		index_inserted = get_child_count()
	get_tree().get_root().remove_child(node)
	add_child(node)
	move_child(node, index_inserted)
	deckRoot.AddCardToDeckList(node.cardData, index_inserted)

func AddCardToDeckFromRightClick(node):
	var new_card = cardBtn.duplicate()
	add_child(new_card)
	move_child(new_card, get_child_count())
	new_card.set_cardPic(node.get_cardPic_texture())
	new_card.set_cardData(node.get_cardData())
	deckRoot.AddCardToDeckList(node.cardData, get_child_count()-1)
