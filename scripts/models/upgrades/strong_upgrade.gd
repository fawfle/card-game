class_name StrongUpgrade extends UpgradeModel
## Additive damage

var _damage_additive: int = 0

func get_description() -> String: return "Increases damage by %s." % _damage_additive

func set_amounts(damage_additive: int) -> StrongUpgrade:
	_damage_additive = damage_additive
	return self

func upgrade_damage_additive(damage_amount: float) -> float:
	return _damage_additive
