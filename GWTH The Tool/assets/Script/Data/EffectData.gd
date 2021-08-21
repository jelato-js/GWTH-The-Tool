extends Object
class_name EffectData

enum VALUE_TYPE {
	No_Value,
	Constant
}
enum COND_TYPE {
	When_Summoned,
	Activate,
	When_Destroyed,
	
	Check_Local_Memory_X_is_Y,
	Check_Local_Memory_X_has_Y,
	
	Check_Target_LM_Race
	
}
enum COST_TYPE {
	NO_COST
}
enum ACTION_TYPE {
	Damage,
	Heal,
	Draw_Cards,
	
	Gain_ATK_Up_X,
	Gain_HP_Up_X
	Gain_State_A,
	
	
	Set_Local_Memory_X_to_Y,
	Remember_Target_LM,
	Show_Choice
}
enum STATE_TYPE {
	Attack_All,
	Random_Value_Attack
}
enum TARGET_TYPE {
	No_Target,
	Self,
	Player_1,
	Player_2
	Chose_1_Player,
	Random_1_Player,
	All_Player,
	
	Chose_X_Hollow_Field,
	Random_X_Hollow_Field,
	
	Chose_X_Hollow_Player_1,
	All_Hollow_Player_1
}
class Cond:
	var type: int
	var valueType: int
	var argument : Array = []
	var force : bool = true

class Cost:
	var type: int
	var valueType: int
	var argument : Array = []
	var force : bool = true

class Action:
	var type: int
	var valueType: int
	var targetType: int
	var argument : Array = []
	var force : bool = true
	var wait : bool = false

var effectLabel : String = ""

var condition : Array = []
var cost : Array = []
var action : Array = []

var effectId : int

#------------------------------------

func _init():
	pass

