extends Node
class_name CardCondition

enum ConditionType {
	Player,
	Card,
	Battler
}

enum PlayerCondidionType {
	Variable,
	Have
}
enum CardCondidionType {
	Id,
	Variable,
	Family,
	Race,
	Element,
	Special
}
enum BattlerCondidionType {
	State
}
class VariableCondidion:
	var number1: int = 0
	var operator: int = 0
	var checkType: int = 0#NumberValueType
	var number2: int = 0
	var variableName: String

var conditionType: int
var conditionWhat: int

var cardId: String = ""

var variableCond: VariableCondidion = VariableCondidion.new()

var family: String = ""
var race: String = ""
var element: int
var special: int

var state_value: StateValue = StateValue.new()

var optional: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_help_text(show_optional: bool = false) -> String:
	var text = ""
	if show_optional and optional:
		text += "(Optional) "
	match(conditionType):
		ConditionType.Player:
			text += "Player | "
			match(conditionWhat):
				PlayerCondidionType.Variable:
					text += "%s %s " % [EnumData.PlayerAttributeCond.keys()[variableCond.number1], EnumData.OperatorValue()[variableCond.operator]]
					match(variableCond.checkType):
						AmountNumber.NumberValueType.Constant:
							text += "%s" % variableCond.number2
						AmountNumber.NumberValueType.Player:
							text += "%s" % EnumData.PlayerAttributeCond.keys()[variableCond.number2]
						AmountNumber.NumberValueType.Opponent:
							text += "Opponent's %s" % EnumData.PlayerAttributeCond.keys()[variableCond.number2]
						AmountNumber.NumberValueType.LM:
							text += "LM:%s" % variableCond.variableName
				PlayerCondidionType.Have:
					text += "have %s in control" % cardId
		ConditionType.Card:
			text += "Card | "
			match(conditionWhat):
				CardCondidionType.Id:
					text += "is %s" % variableCond.cardId
				CardCondidionType.Variable:
					text += "%s %s " % [EnumData.CardAttributeCond.keys()[variableCond.number1], EnumData.OperatorValue()[variableCond.operator]]
					match(variableCond.checkType):
						AmountNumber.NumberValueType.Constant:
							text += "%s" % variableCond.number2
						AmountNumber.NumberValueType.LM:
							text += "LM:%s" % variableCond.variableName
				CardCondidionType.Family:
					text += "is %s" % family
				CardCondidionType.Race:
					text += "is %s" % race
				CardCondidionType.Element:
					text += "is %s" % CardData.CARD_ELEMENT.keys()[element]
				CardCondidionType.Special:
					text += "is %s" % EnumData.CardSpecialCond.keys()[special]
		ConditionType.Battler:
			text += "Battler | "
			text += "have [%s] state" % StateValue.StateId.keys()[state_value.id]
			match(state_value.option_type):
				StateValue.StateOptionType.BuffId:
					text += " with [%s]" % StateValue.BuffCardState.keys()[state_value.option_id]
				StateValue.StateOptionType.CardType:
					text += " with [%s]" % CardData.CARD_TYPE.keys()[state_value.option_id]
				StateValue.StateOptionType.AttackType:
					text += " with [%s]" % EnumData.AttackType.keys()[state_value.option_id]
	return text
