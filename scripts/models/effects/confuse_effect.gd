class_name ConfusedEffect extends EffectModel

func get_title() -> String: return "Confuse"

func get_icon() -> Texture2D: return preload("res://assets/icons/misdirection.png")

func get_description() -> String: return "Enemy's actions are %d%% slower." % (get_amount_modifier() * 100)

func modify_move_time_delta_multiplicative(creature: Creature, _delta: float) -> float:
	if owner == creature:
		return 1.0 - get_amount_modifier()
	return 1.0

func get_amount_modifier() -> float:
	return amount * 0.1
