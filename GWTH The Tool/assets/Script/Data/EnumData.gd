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

enum AttackType {
	Attack,
	Magic
}

#--------------

enum TargetMethod {
	No_Target,
	All,
	Choose,
	Random
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
	ACC,
	EVA,
	Critical_Chance,
	Critical_Damage,
	Critical_Protection,
	RepeatAttack,
	HpRegen,
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
	Number_of_Area_in_Abyss,
}

enum CardAttributeCond {
	Grade,
	Level,
	HP,
	MaxHP,
	ATK,
	DEF,
	ACC,
	EVA,
	Critical_Chance,
	Critical_Damage,
	Critical_Protection,
	AreaTurn,
	Original_HP,
	Original_ATK,
	Original_Grade,
	Original_AreaTurn,
	RepeatAttack,
	HpRegen
}

enum CardSpecialCond {
	Lowest_Grade,
	Lowest_Level,
	Lowest_HP,
	Lowest_MaxHP,
	Lowest_ATK,
	Lowest_DEF,
	Lowest_ACC,
	Lowest_EVA,
	Lowest_Critical_Chance,
	Lowest_Critical_Damage,
	Lowest_Critical_Protection,
	Lowest_AreaTurn,
	Lowest_Original_HP,
	Lowest_Original_ATK,
	Lowest_Original_Grade,
	Lowest_Original_AreaTurn,
	Lowest_RepeatAttack,
	Lowest_HpRegen,
	Highest_Grade,
	Highest_Level,
	Highest_HP,
	Highest_MaxHP,
	Highest_ATK,
	Highest_DEF,
	Highest_ACC,
	Highest_EVA,
	Highest_Critical_Chance,
	Highest_Critical_Damage,
	Highest_Critical_Protection,
	Highest_AreaTurn,
	Highest_Original_HP,
	Highest_Original_ATK,
	Highest_Original_Grade,
	Highest_Original_AreaTurn,
	Highest_RepeatAttack,
	Highest_HpRegen
}

#--------------



#--------------

enum ActionEffect {
	G
}
