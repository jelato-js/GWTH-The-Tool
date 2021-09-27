extends Node
class_name AmountNumber

enum NumberValueType {
	Constant,
	LM,
	Special,
	Player,
	Opponent
}


var type: int
var value: int = 0
var variableName: String = ""
var special: int = 0


