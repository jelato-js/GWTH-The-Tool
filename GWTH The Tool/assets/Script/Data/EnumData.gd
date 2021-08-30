extends Node


enum EffectTimes {
	UNIDENTIFIED,
	ONECE_PER_TURN,
	TWICE_PER_TURN
}
enum EffectBuffState {
	ATTACK_ALL_HOLLOW,
	ATK_BUFF,
	DEF_BUFF,
} 
enum EffectBuffStateDuration {
	FOREVER,
	UNTILL_END_PHASE,
	UNTILL_X_TRUN
}

# EffectBuffStateDuration value

#--------------

enum TargetMethod {
	No_Target,
	All,
	Choose,
	Random
}
enum NumberValueType {
	Constant,
	LM,
	Special,
	Player,
	Opponent
}

func OperatorValue():
	return {
		0:">",
		1:"<",
		2:">=",
		3:"<=",
		4:"==",
		5:"!="
	}

enum PlayerAttributeCond {
	HP,
	MaxHP,
	ATK,
	DEF,
	Number_of_Card_in_Deck,
	Number_of_Card_in_Hand,
	Number_of_Card_in_Field,
	Number_of_Card_in_Abyss,
	Number_of_Hollow_in_Deck,
	Number_of_Hollow_in_Hand,
	Number_of_Hollow_in_Field,
	Number_of_Hollow_in_Abyss,
	Number_of_Magic_in_Deck,
	Number_of_Magic_in_Hand,
	Number_of_Magic_in_Abyss,
	Number_of_Area_in_Deck,
	Number_of_Area_in_Hand,
	Number_of_Area_in_Field,
	Number_of_Area_in_Abyss
}

enum CardAttributeCond {
	HP,
	MaxHP,
	ATK,
	DEF,
	Grade,
	Level,
	AreaTurn,
	Original_HP,
	Original_ATK,
	Original_Grade,
	Original_AreaTurn,
}

enum CardSpecialCond {
	Lowest_HP,
	Lowest_MaxHP,
	Lowest_ATK,
	Lowest_DEF,
	Lowest_Grade,
	Lowest_Level,
	Lowest_AreaTurn,
	Lowest_Original_HP,
	Lowest_Original_ATK,
	Lowest_Original_Grade,
	Lowest_Original_AreaTurn,
	Highest_HP,
	Highest_MaxHP,
	Highest_ATK,
	Highest_DEF,
	Highest_Grade,
	Highest_Level,
	Highest_AreaTurn,
	Highest_Original_HP,
	Highest_Original_ATK,
	Highest_Original_Grade,
	Highest_Original_AreaTurn
}
