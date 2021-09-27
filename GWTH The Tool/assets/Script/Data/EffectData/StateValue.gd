extends Node
class_name StateValue

enum BuffCardState {
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
	RepeatAttack,
	HpRegen
}

enum StateId {
	BuffState, # StateId
	DebuffState, # StateId
	Bond_Heal, # Value
	Bond_Damage, # Value
	Attack_RandomValue, # Value1, Value2
	Unaffected, # Hollow, Magic, Area
	Reflect, # Attack, Magic
	Attack_All,
	Invisible,
	Stun,
	Storm,
	EyeDrive,
	WitchsCurse,
	NegateEffect,
	Life,
	CounterAttack,
	NegateActionWithCard,
	#SweetShield,
	Absorb,
	Peace,
	Ward
}
enum StateOptionType {
	NoOption,
	BuffId,
	CardType,
	AttackType
}

var id: int
var option_type: int = StateOptionType.NoOption
var option_id: int
