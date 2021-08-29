extends Node
class_name CardCondition

enum ConditionType {
	Player,
	Card
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
class VariableCondidion:
	var number1: int = 0
	var operator: int = 0
	var checkType: int = 0#NumberValueType
	var number2: int = 0
	var variableName: String

var conditionType: int
var conditionWhat: int

var cardId: String

var variableCond: VariableCondidion = VariableCondidion.new()

var family: String
var race: String
var element: String
var special: int

var optional: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
