extends Object
class_name CardData

enum CARD_TYPE {
	Hollow,
	Magic,
	Aera
}
enum CARD_ELEMENT {
	Fire,
	Water,
	Earth,
	Wind,
	
	Holy,
	Shadow, #Darkness,
	
	Lightning, #LIGHTNING
	Ice
}
enum CARD_MAGIC_TYPE {
	Normal,
}
#-----

var cardId : String = ""

var cardName : String = ""
var cardType : int = 0

var cardFamily : String = ""

var cardRace : String = ""
var cardElement : int = 0
var cardGrade : int = 0
var cardLevel : int = 0
var cardAtk : int = 0
var cardHP : int = 1

var cardMagicType : int = 0

var cardAreaTurn : int = 0

var cardAlternative : bool = false
var cardRealId : String = ""

#-----

var cardEffect : Array = []

#-----

var cardDescription : String = ""
var cardFlavor : String = ""
var cardArtist : String = ""

var cardEffectText : Array = []

#----------------------------------
#var cardPicType : int = 0
var cardPic : Image = Image.new()
var cardPicTexture : ImageTexture = ImageTexture.new()
#----------------------------------
var cardSetBox : String = ""
var cardRarity : int = 0
#----------------------------------

func _init(id = null):
	if id != null:
		cardId = id

func get_cardId():
	return cardId

func get_cardType():
	return cardType
