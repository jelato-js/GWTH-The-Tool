extends Node
class_name Target

class AmountValue:
	var fromValue: AmountNumber = AmountNumber.new()
	var toValue: AmountNumber = AmountNumber.new()

class TargetWhat:
	var user: bool
	var player1: bool
	var player2: bool
	var hollow: bool
	var magic: bool
	var area: bool

class TargetWhereOf:
	var player1: bool = false
	var player2: bool = false
class TargetWhere:
	var check: bool = false
	var of: TargetWhereOf = TargetWhereOf.new()
class Where:
	var field: TargetWhere = TargetWhere.new()
	var hand: TargetWhere = TargetWhere.new()
	var deck: TargetWhere = TargetWhere.new()
	var abyss: TargetWhere = TargetWhere.new()
	var outer: bool = false

var method: int
var amount: AmountValue = AmountValue.new()
var target: TargetWhat = TargetWhat.new()
var where: Where = Where.new()

var targetCond: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

