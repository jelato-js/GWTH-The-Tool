extends Button

onready var cardPic = $HBoxContainer/TextureRect
onready var richText = $HBoxContainer/RichTextLabel

onready var cardData : CardData = null

var allcard_container : VBoxContainer = null
var deck_container : GridContainer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	allcard_container = get_tree().get_nodes_in_group("AllCardContainer")[0]
	deck_container = get_tree().get_nodes_in_group("DeckContainer")[0]

func set_cardPic(textureRect):
	print_debug(cardPic.texture)
	cardPic.texture = textureRect

func set_cardData(data : CardData):
	cardData = data

func get_cardPic_texture() -> Texture:
	return cardPic.texture

func get_cardData() -> CardData:
	return cardData

func refresh_richText():
	if cardData != null:
		var rich_text = "%s\n%s [*%s]\nATK %s HP %s" % [cardData.cardName, cardData.cardRace, cardData.cardGrade, cardData.cardAtk, cardData.cardHP]
		richText.text = rich_text

func _on_AllCardBtn_gui_input(event):
	if Input.is_action_just_pressed("ui_click"):
		allcard_container.Card_clicked(self)
	if Input.is_action_just_pressed("ui_right_click"):
		deck_container.AddCardToDeckFromRightClick(self)
