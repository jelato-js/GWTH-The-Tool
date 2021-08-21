extends Button

onready var cardPic : TextureRect = $TextureRect
onready var cardData : CardData = null

var selected = false
var hover = false
var mouse_off

var card_in_deck = true

var deck_container : GridContainer = null
var deckRoot : Control = null

func _ready():
	modulate = Color( .85, .85, .85, 1 )
	deck_container = get_tree().get_nodes_in_group("DeckContainer")[0]
	deckRoot = get_tree().get_nodes_in_group("DeckRoot")[0]

func _on_CardInDeckBtn_gui_input(event):
	if Input.is_action_just_pressed("ui_click"):
		if card_in_deck:
			deck_container.Card_clicked(self)
		elif check_mouse_click_in_deckcontainer():
			deck_container.MoveCardToDeck(self)
			selected = false
			card_in_deck = true
			hover = false
		else:
			queue_free()
		mouse_off = get_local_mouse_position()
	if Input.is_action_just_pressed("ui_right_click"):
		var index_node = deck_container.get_children().find(self)
		deckRoot.RemoveAddFromDeckList(index_node)
		queue_free()

func _physics_process(delta):
	if selected:
		rect_global_position = ( lerp( rect_global_position, get_global_mouse_position() - mouse_off, 50 * delta) )
	modulate = Color( 1, 1, 1, 1 ) if hover else Color( .85, .85, .85, 1 )

func Selected():
	card_in_deck = false
	selected = true
	

func _on_CardInDeckBtn_mouse_entered():
	hover = true

func _on_CardInDeckBtn_mouse_exited():
	hover = false

func check_mouse_click_in_deckcontainer() -> bool:
	var rect_deckcontainer = deck_container.get_global_rect()
	var mouse_pos = get_global_mouse_position()
	var check_x : bool = mouse_pos.x in range(rect_deckcontainer.position.x, rect_deckcontainer.position.x + rect_deckcontainer.size.x)
	var check_y : bool = mouse_pos.y in range(rect_deckcontainer.position.y, rect_deckcontainer.position.y + rect_deckcontainer.size.y)
	return (check_x && check_y)

func set_cardPic(textureRect):
	cardPic.texture = textureRect

func set_cardData(data : CardData):
	cardData = data

