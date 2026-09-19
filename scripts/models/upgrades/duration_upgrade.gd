class_name DurationUpgrade extends UpgradeModel

var _duration_modifier: float = 0

func get_description() -> String: return "Changes duration by %d." % _duration_modifier

func set_amounts(duration_modifier: float) -> DurationUpgrade:
	_duration_modifier = duration_modifier
	return self

func upgrade_duration_additive(_duration_amount: float) -> float:
	return _duration_modifier

func can_apply(card_model: CardModel) -> bool:
	return card_model.duration != null
