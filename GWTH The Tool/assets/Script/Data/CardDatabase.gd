extends Node

var card = {}
var pic = {}
var texture = {}

var data_family = []
var data_race = []

func _init():
	reset_data()

func reset_data():
	data_family.clear()
	data_race.clear()
	
	card.clear()
	pic.clear()
	texture.clear()

func add_card(cardId, cardData):
	card[cardId] = cardData

func add_pic(cardId, cardImage):
	pic[cardId] = cardImage

func add_texture(cardId, cardTexture):
	texture[cardId] = cardTexture

func remove_card(cardId):
	card.erase(cardId)

func remove_texture(cardId):
	texture.erase(cardId)

#------
func check_family(familyId) -> bool :
	return data_family.has(familyId)

func add_family(familyId):
	if not check_family(familyId):
		data_family.append(familyId)

func check_race(raceId) -> bool :
	return data_race.has(raceId)

func add_race(raceId):
	if not check_race(raceId):
		data_race.append(raceId)

#----------------------------------

func get_texture(cardId) -> Texture :
	var texture_return = texture[cardId]
	return texture_return

