extends Node
class_name EffectCondition

enum Condition {
	No_Condition
	Summoned,
	Active,
	Attribute
	State,
	
	Sacrificed,
	Drawn,
	AddedToHand,
	AddedToDeck,
	SendToAbyss,
	
	
	Attack,
	Attacked,
	Battle,
	Defense,
	Destroyed,
	
	LM_
}
var cond:int = Condition.No_Condition
#-----------------------
var summoned_custom:bool = false
class Where:
	var field: bool = false
	var hand: bool = false
	var deck: bool = false
	var abyss: bool = false
	var outer: bool = false
var summoned_from: Where = Where.new
#-----------------------
enum ActivePer {
	PerTurn,
	PerCard,
	PerGame
}
var active_times:int = 0
var active_per:int = ActivePer.PerTurn
#-----------------------
var attribute_what:int = EnumData.CardAttributeCond.Grade
var attribute_operator:int = 0
var attribute_value: AmountNumber = AmountNumber.new()
#-----------------------
var state_value:StateValue = StateValue.new()
#-----------------------



