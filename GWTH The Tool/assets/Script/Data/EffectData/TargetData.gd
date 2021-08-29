extends Node
class_name Target

class AmountNumber:
	var type = EnumData.NumberValueType
	var value: int
	var variableName: String
	var special: int

class AmountValue:
	var fromValue: AmountNumber
	var toValue: AmountNumber

class TargetWhat:
	var user: bool
	var player1: bool
	var player2: bool
	var hollow: bool
	var magic: bool
	var area: bool

class TargetWhereOf:
	var player1: bool
	var player2: bool
class TargetWhere:
	var check: bool
	var of: TargetWhereOf
class Where:
	var field: TargetWhere
	var hand: TargetWhere
	var deck: TargetWhere
	var abyss: TargetWhere
	var outer: bool

var method: int
var amount: AmountValue
var target: TargetWhat
var where: Where

var targetCond: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

